class Azet < Formula
  desc "AI coding agent in your terminal, by AZET LLC"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "a1721e63deb719163d0cd92c83a669bd0887fa3dd2f9c1e54c6ec50586778ae0"
  license "MIT"

  # shortcut: macOS only; the agent build script also makes Linux binaries when we add Linux
  depends_on :macos
  # azet app runs on the agent binary's own Bun runtime: no Node.js needed
  depends_on "qrencode" # azet app --lan prints a QR code for the phone

  # azet-agent = our build of Pi (MIT), see agent-build/ in the repo; unchanged since 0.8.0, so its files stay on the v0.8.0 release
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.8.0/azet-agent-darwin-arm64.tar.gz"
      sha256 "ed8658b3de662fb68592dc77d504f1ea1755ee329b002c5c3fe105a185991c03"
    end
    on_intel do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.8.0/azet-agent-darwin-x64.tar.gz"
      sha256 "07316efd6d3fa057bd303f279b370bad7b64a5de7d541db9ecc052e8f407d8ce"
    end
  end

  def install
    libexec.install "azet", "azet.ts", "SYSTEM.md", "sandbox.sb", "app", "extensions"
    prefix.install "LICENSE-pi", "THIRD_PARTY_NOTICES.md" # LICENSE and README are installed by brew itself
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  def caveats
    <<~EOS
      The browser tool needs agent-browser:  brew install agent-browser && agent-browser install
      Terminals in azet app need python3:  xcode-select --install
    EOS
  end

  test do
    assert_match "azet 0.9.2", shell_output("#{bin}/azet --version")
    assert_match "on your phone", shell_output("#{bin}/azet app --help")
    assert_path_exists libexec/"app/index.html"
    assert_match "azet", shell_output("#{bin}/azet --help-all")
    assert_path_exists libexec/"sandbox.sb"
    assert_path_exists libexec/"extensions/subagent/index.ts"
    assert_match "Mario Zechner", (prefix/"LICENSE-pi").read
    assert_path_exists libexec/"azet-agent/THIRD_PARTY_NOTICES.md"
  end
end
