class Azet < Formula
  desc "AI coding agent in your terminal, by AZET LLC"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "553c3433fe4f8252410cfc789ed0ac2fd56c95b14c9d25cb80277df732784a83"
  license "MIT"

  # shortcut: macOS only; the agent build script also makes Linux binaries when we add Linux
  depends_on :macos

  # azet-agent = our build of Pi (MIT), see agent-build/ in the repo
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.4.0/azet-agent-darwin-arm64.tar.gz"
      sha256 "3a6940a2d5f2707650a54cf308213130754a4b10e5900b1bce9cc7ac1ce66e43"
    end
    on_intel do
      url "https://github.com/azet-llc/azet-cli/releases/download/v0.4.0/azet-agent-darwin-x64.tar.gz"
      sha256 "f7cf9c3e8751207cff887983f56bb3e93cb4537b8116805bb42519ac407f9f98"
    end
  end

  def install
    libexec.install "azet", "azet.ts", "SYSTEM.md", "sandbox.sb"
    prefix.install "LICENSE-pi", "THIRD_PARTY_NOTICES.md" # LICENSE and README are installed by brew itself
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  test do
    assert_match "azet 0.4.0", shell_output("#{bin}/azet --version")
    assert_match "azet", shell_output("#{bin}/azet --help-all")
    assert_path_exists libexec/"sandbox.sb"
    assert_match "Mario Zechner", (prefix/"LICENSE-pi").read
    assert_path_exists libexec/"azet-agent/THIRD_PARTY_NOTICES.md"
  end
end
