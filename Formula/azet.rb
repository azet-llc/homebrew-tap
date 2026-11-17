class Azet < Formula
  desc "AI coding agent for macOS, by AZET LLC"
  homepage "https://azet.io/products/azet-agent"
  url "https://github.com/azet-llc/azet/releases/download/v0.9.10/azet-0.9.10-darwin.tar.gz"
  sha256 "d8eb6ceec68b89649a2e11b001deeec5f9dfe96abf0d254428d66b953b313e00"
  license :cannot_represent # proprietary (AZET LLC); third-party parts keep their licenses, see THIRD_PARTY_NOTICES.md

  # shortcut: macOS only; Linux comes with the Linux build
  depends_on :macos

  # azet-agent: the agent runtime
  resource "agent" do
    on_arm do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.2/azet-agent-darwin-arm64.tar.gz"
      sha256 "f97439ac53c862ab906b83459c6488e715df52750c63f3c917b8ede5e9429a1c"
    end
    on_intel do
      url "https://github.com/azet-llc/azet/releases/download/agent-0.8.2/azet-agent-darwin-x64.tar.gz"
      sha256 "d5cca0461abf0ee4bce0b8035804662bafdbf2290f19bf0b86771cdec39b314b"
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
