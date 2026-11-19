cask "azet-desktop" do
  # The app updates itself (it checks the release feed every 30 minutes), so the cask follows the latest release.
  version :latest
  sha256 :no_check

  url "https://github.com/azet-llc/azet-desktop/releases/latest/download/azet-macos-arm64.dmg",
      verified: "github.com/azet-llc/azet-desktop/"
  name "AZET Desktop"
  desc "Run AI coding agents side by side, with a browser and your phone, by AZET LLC"
  homepage "https://azet.io/"

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "AZET Desktop.app"

  zap trash: [
    "~/Library/Application Support/azet-desktop",
    "~/Library/Preferences/io.azet.desktop.plist",
  ]
end
