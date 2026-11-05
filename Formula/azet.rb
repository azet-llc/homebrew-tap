class Azet < Formula
  desc "AI coding agent in your terminal, by AZET LLC"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "424e2beca82dd0015917c2ddf776b480e1c190f5cc8654ad3a226eca800714c0"
  license "MIT"

  # shortcut: macOS only; the agent build script also makes Linux binaries when we add Linux
  depends_on :macos

  # azet-agent = our build of Pi (MIT), see agent-build/ in the repo
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.3.0/azet-agent-darwin-arm64.tar.gz"
      sha256 "b2310b5f643d3e33e151579a9be34919c817ada7c6f654195232851f0e5e8323"
    end
    on_intel do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.3.0/azet-agent-darwin-x64.tar.gz"
      sha256 "9f0f5ebe0825ef6fcfbdb3cc7cade2a428e4e1961657d30c6e52d67fa1e1c020"
    end
  end

  def install
    libexec.install "azet", "azet.ts", "SYSTEM.md"
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  test do
    assert_match "azet 0.3.0", shell_output("#{bin}/azet --version")
    assert_match "azet", shell_output("#{bin}/azet --help-all")
  end
end
