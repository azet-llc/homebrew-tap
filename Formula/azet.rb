class Azet < Formula
  desc "AI coding agent for macOS, by AZET LLC"
  homepage "https://azet.io/products/azet-agent"
  url "https://github.com/azet-llc/azet/releases/download/v0.9.3/azet-0.9.3-darwin.tar.gz"
  sha256 "66476d20b1ec77f706d57193078f28270d0752a77ad63017048e2ef6ac6b2d1f"
  license :cannot_represent # proprietary (AZET LLC); third-party parts keep their licenses, see THIRD_PARTY_NOTICES.md

  # shortcut: macOS only; Linux comes with the Linux build
  depends_on :macos

  # azet-agent: the agent runtime (built on Pi, MIT), unchanged since 0.8.0
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.0/azet-agent-darwin-arm64.tar.gz"
      sha256 "ed8658b3de662fb68592dc77d504f1ea1755ee329b002c5c3fe105a185991c03"
    end
    on_intel do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.0/azet-agent-darwin-x64.tar.gz"
      sha256 "07316efd6d3fa057bd303f279b370bad7b64a5de7d541db9ecc052e8f407d8ce"
    end
  end

  def install
    libexec.install "azet", "azet.js", "SYSTEM.md", "sandbox.sb", "app", "extensions"
    prefix.install "LICENSE", "LICENSE-pi", "THIRD_PARTY_NOTICES.md"
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  def caveats
    <<~EOS
      The Mac app (no Terminal needed): https://azet.io/products/azet-agent
      The browser tool needs agent-browser:  brew install agent-browser && agent-browser install
      Terminals in azet app need python3:  xcode-select --install
    EOS
  end

  test do
    assert_match "azet 0.9.3", shell_output("#{bin}/azet --version")
    assert_match "on your phone", shell_output("#{bin}/azet app --help")
    assert_path_exists libexec/"app/index.html"
    assert_path_exists libexec/"app/server.js"
    assert_match "azet", shell_output("#{bin}/azet --help-all")
    assert_path_exists libexec/"sandbox.sb"
    assert_path_exists libexec/"extensions/subagent/index.js"
    assert_match "AZET LLC", (prefix/"LICENSE").read
    assert_match "Mario Zechner", (prefix/"LICENSE-pi").read
  end
end
