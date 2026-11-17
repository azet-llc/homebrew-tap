class Azet < Formula
  desc "AI coding agent for macOS, by AZET LLC"
  homepage "https://azet.io/products/azet-agent"
  url "https://github.com/azet-llc/azet/releases/download/v0.9.8/azet-0.9.8-darwin.tar.gz"
  sha256 "4f6b2a19e92383528053503e62880a07e735d89847ac6c4a55aa778e6cd4de93"
  license :cannot_represent # proprietary (AZET LLC); third-party parts keep their licenses, see THIRD_PARTY_NOTICES.md

  # shortcut: macOS only; Linux comes with the Linux build
  depends_on :macos

  # azet-agent: the agent runtime (built on Pi, MIT), 0.8.1 ships without docs and examples
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.1/azet-agent-darwin-arm64.tar.gz"
      sha256 "fadd18568ae00fc01d028fb1dbcbf2cf09228fdce13544325ae7e28ed61eee8d"
    end
    on_intel do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.1/azet-agent-darwin-x64.tar.gz"
      sha256 "510d9f54bd394c3eaa4fe5a2e15ffa76b0b717749be4523c63a49e40ba49386d"
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
