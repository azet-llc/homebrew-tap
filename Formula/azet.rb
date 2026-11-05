class Azet < Formula
  desc "AI coding agent in your terminal, free trial with no key"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "06c7953723ab1707b831284364d029589ad7d31bcdea9ff09353a66945983529"
  license "MIT"

  # shortcut: macOS only; Pi also ships linux tarballs when we add Linux
  depends_on :macos

  resource "pi" do
    on_arm do
      url "https://github.com/earendil-works/pi/releases/download/v1.5.0/pi-darwin-arm64.tar.gz"
      sha256 "a9bf0d82d58d2a7d337f4ae4171b5fc9ebffe42509527a831364c4b65adf2cdf"
    end
    on_intel do
      url "https://github.com/earendil-works/pi/releases/download/v1.5.0/pi-darwin-x64.tar.gz"
      sha256 "f41b26cd9a1754abe259e05a421fb33b00936779cb0783c893a6389d1bd2ee0d"
    end
  end

  def install
    libexec.install "azet", "azet.ts"
    resource("pi").stage { (libexec/"pi").install Dir["*"] }
    (bin/"azet").write_env_script libexec/"azet", AZET_PI: libexec/"pi/pi"
  end

  test do
    assert_match "azet 0.2.1", shell_output("#{bin}/azet --version")
  end
end
