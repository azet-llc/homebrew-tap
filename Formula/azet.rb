class Azet < Formula
  desc "AI coding agent in your terminal, free trial with no key"
  homepage "https://github.com/azet-llc/azet-cli"
  url "https://github.com/azet-llc/azet-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c241d98145bccf4ed459e805914d138046bb1dbbbee1da22558c36619899f985"
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
    libexec.install "azet"
    resource("pi").stage { (libexec/"pi").install Dir["*"] }
    (bin/"azet").write_env_script libexec/"azet", AZET_PI: libexec/"pi/pi"
  end

  test do
    assert_match "Usage", shell_output("#{libexec}/pi/pi --help")
  end
end
