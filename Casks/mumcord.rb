cask "mumcord" do
  version "0.7.2"
  sha256 "eeb5d16e896a1565b1434afdacfd77d79d7f340b5b867e6ac3099381883838af"

  url "https://github.com/Mumcord/mumcord/releases/download/v#{version}/Mumcord_#{version}_universal.dmg",
      verified: "github.com/Mumcord/mumcord/"
  name "Mumcord"
  desc "Voice chat client for Mumble servers"
  homepage "https://mumcord.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :high_sierra

  app "Mumcord.app"

  zap trash: [
    "~/Library/Application Support/app.mumcord.client",
    "~/Library/Caches/app.mumcord.client",
    "~/Library/HTTPStorages/app.mumcord.client",
    "~/Library/Logs/app.mumcord.client",
    "~/Library/Preferences/app.mumcord.client.plist",
    "~/Library/Saved Application State/app.mumcord.client.savedState",
    "~/Library/WebKit/app.mumcord.client",
  ]
end
