cask "mumcord" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.0"
  sha256 arm:   "1cf51fce9e3c1296610550a2d8319c579ff8655a1c4ee7dbbee0c881240382f4",
         intel: "b81f20c03f2e484ae00423c89564a5805bbd2acccccc7adbd2029454684a8158"

  url "https://github.com/Mumcord/mumcord/releases/download/v#{version}/Mumcord_#{version}_#{arch}.dmg",
      verified: "github.com/Mumcord/mumcord/"
  name "Mumcord"
  desc "Voice chat client for Mumble servers"
  homepage "https://mumcord.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

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
