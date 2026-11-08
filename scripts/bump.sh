#!/usr/bin/env bash
# Points the cask and the formula at the latest Mumcord release, with the checksums the release
# publishes in SHA256SUMS. Prints the new version, or nothing when both are up to date.
set -euo pipefail

repo="Mumcord/mumcord"
tag=$(gh release view --repo "$repo" --json tagName --jq .tagName)
version=${tag#v}
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' Casks/mumcord.rb)
[ "$version" = "$current" ] && exit 0

sums=$(gh release download "$tag" --repo "$repo" --pattern SHA256SUMS --output -)
sum() {
  local hash
  hash=$(awk -v f="$1" '$2 == f { print $1 }' <<<"$sums")
  if [ -z "$hash" ]; then
    echo "SHA256SUMS of $tag has no $1" >&2
    exit 1
  fi
  echo "$hash"
}

dmg=$(sum "Mumcord_${version}_universal.dmg")
amd64=$(sum "Mumcord_${version}_amd64.AppImage")
arm64=$(sum "Mumcord_${version}_aarch64.AppImage")

sed -i \
  -e "s/^  version \".*\"$/  version \"$version\"/" \
  -e "s/^  sha256 \".*\"$/  sha256 \"$dmg\"/" \
  Casks/mumcord.rb
sed -i -e "s/^  version \".*\"$/  version \"$version\"/" Formula/mumcord.rb
# The first sha256 in the formula is the Intel AppImage, the second the ARM one.
awk -v a="$amd64" -v b="$arm64" '
  /^      sha256 "/ { n++; sub(/"[0-9a-f]+"/, "\"" (n == 1 ? a : b) "\"") }
  { print }
' Formula/mumcord.rb >Formula/mumcord.rb.new
mv Formula/mumcord.rb.new Formula/mumcord.rb
echo "$version"
