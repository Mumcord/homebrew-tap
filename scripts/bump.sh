#!/usr/bin/env bash
# Points the cask and the formula at the latest Mumcord release, with the checksums the release
# publishes in SHA256SUMS. Prints the new version, or nothing when both are up to date.
set -euo pipefail

repo="Mumcord/mumcord"
tag=$(gh release view --repo "${repo}" --json tagName --jq .tagName)
version=${tag#v}
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' Casks/mumcord.rb)
[[ "${version}" = "${current}" ]] && exit 0

sums=$(gh release download "${tag}" --repo "${repo}" --pattern SHA256SUMS --output -)
sum() {
  local hash
  hash=$(awk -v f="$1" '$2 == f { print $1 }' <<<"${sums}")
  if [[ -z "${hash}" ]]
  then
    echo "SHA256SUMS of ${tag} has no $1" >&2
    exit 1
  fi
  echo "${hash}"
}

amd64=$(sum "Mumcord_${version}_amd64.AppImage")
arm64=$(sum "Mumcord_${version}_aarch64.AppImage")

# Up to 0.7.x macOS ships one universal DMG; from 0.8.0 on one DMG per architecture (#663).
if grep -q " Mumcord_${version}_universal.dmg$" <<<"${sums}"
then
  dmg=$(sum "Mumcord_${version}_universal.dmg")
  arch_line=""
  sha_lines="  sha256 \"${dmg}\""
  file="Mumcord_#{version}_universal.dmg"
else
  dmg_arm=$(sum "Mumcord_${version}_aarch64.dmg")
  dmg_intel=$(sum "Mumcord_${version}_x64.dmg")
  arch_line=$'  arch arm: "aarch64", intel: "x64"\n\n'
  sha_lines="  sha256 arm:   \"${dmg_arm}\",
         intel: \"${dmg_intel}\""
  file="Mumcord_#{version}_#{arch}.dmg"
fi

{
  printf 'cask "mumcord" do\n%s' "${arch_line}"
  printf '  version "%s"\n%s\n\n' "${version}" "${sha_lines}"
  sed -n '/^  url "/,$p' Casks/mumcord.rb |
    sed -E "s|Mumcord_#\{version\}_[^\"]*\.dmg|${file}|"
} >Casks/mumcord.rb.new
mv Casks/mumcord.rb.new Casks/mumcord.rb

# The formula names the version only in its URLs (Homebrew reads it from there).
sed -i -e "s/${current//./\\.}/${version}/g" Formula/mumcord.rb
# The first sha256 in the formula is the Intel AppImage, the second the ARM one.
awk -v a="${amd64}" -v b="${arm64}" '
  /^      sha256 "/ { n++; sub(/"[0-9a-f]+"/, "\"" (n == 1 ? a : b) "\"") }
  { print }
' Formula/mumcord.rb >Formula/mumcord.rb.new
mv Formula/mumcord.rb.new Formula/mumcord.rb
echo "${version}"
