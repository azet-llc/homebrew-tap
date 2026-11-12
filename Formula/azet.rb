class Azet < Formula
  desc "AI coding agent in your terminal, by AZET LLC"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "faa0a86d57e984c876dc25c4fb3c6ac8a8c6f3a1108df7c26ebf2c42488ebbe0"
  license "MIT"

  # shortcut: macOS only; the agent build script also makes Linux binaries when we add Linux
  depends_on :macos

  # azet-agent = our build of Pi (MIT), see agent-build/ in the repo
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.6.0/azet-agent-darwin-arm64.tar.gz"
      sha256 "ed8658b3de662fb68592dc77d504f1ea1755ee329b002c5c3fe105a185991c03"
    end
    on_intel do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.6.0/azet-agent-darwin-x64.tar.gz"
      sha256 "07316efd6d3fa057bd303f279b370bad7b64a5de7d541db9ecc052e8f407d8ce"
    end
  end

  def install
    libexec.install "azet", "azet.ts", "SYSTEM.md", "sandbox.sb"
    prefix.install "LICENSE-pi", "THIRD_PARTY_NOTICES.md" # LICENSE and README are installed by brew itself
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  test do
    assert_match "azet 0.6.0", shell_output("#{bin}/azet --version")
    assert_match "azet", shell_output("#{bin}/azet --help-all")
    assert_path_exists libexec/"sandbox.sb"
    assert_match "Mario Zechner", (prefix/"LICENSE-pi").read
    assert_path_exists libexec/"azet-agent/THIRD_PARTY_NOTICES.md"
  end
end
