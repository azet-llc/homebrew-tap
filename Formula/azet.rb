class Azet < Formula
  desc "AI coding agent for macOS, by AZET LLC"
  homepage "https://azet.io/products/azet-agent"
  url "https://github.com/azet-llc/azet/releases/download/v0.9.21/azet-0.9.21-darwin.tar.gz"
  sha256 "d10538fff28f4bc73191560c0b0e0e340397eed89d6366f6f23939a1a653bce8"
  license :cannot_represent # proprietary (AZET LLC); third-party parts keep their licenses, see THIRD_PARTY_NOTICES.md

  # shortcut: macOS only; Linux comes with the Linux build
  depends_on :macos

  # azet-agent: the agent runtime
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.4/azet-agent-darwin-arm64.tar.gz"
      sha256 "6965e613d49f38493bf1642e8a23aaf7e6bc8fa98f15c81665e9f65afd86226a"
    end
    on_intel do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.4/azet-agent-darwin-x64.tar.gz"
      sha256 "9d39230f18094cdec6355a5663ec63e8d03b606041f6d9cf7597ff4366987cd0"
    end
  end

  def install
    libexec.install "azet", "azet.js", "SYSTEM.md", "sandbox.sb", "app", "extensions", "acp"
    prefix.install "LICENSE", "LICENSE-pi", "THIRD_PARTY_NOTICES.md"
    resource("agent").stage { (libexec/"azet-agent").install Dir["*"] }
    bin.write_exec_script libexec/"azet"
  end

  def caveats
    <<~EOS
      The Mac app (no Terminal needed): https://azet.io/products/azet-agent
      The browser tool uses AZET Desktop when it is installed; otherwise:  brew install agent-browser && agent-browser install
      Terminals in azet app need python3:  xcode-select --install
    EOS
  end

  test do
    assert_match "azet 0.9.4", shell_output("#{bin}/azet --version")
    assert_match "on your phone", shell_output("#{bin}/azet app --help")
    assert_path_exists libexec/"app/index.html"
    assert_path_exists libexec/"app/server.js"
    assert_match "azet", shell_output("#{bin}/azet --help-all")
    assert_path_exists libexec/"sandbox.sb"
    assert_path_exists libexec/"extensions/subagent/index.js"
    assert_path_exists libexec/"acp/azet-acp.js"
    assert_match "AZET LLC", (prefix/"LICENSE").read
    assert_match "Mario Zechner", (prefix/"LICENSE-pi").read
  end
end
