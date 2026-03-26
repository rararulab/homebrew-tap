class RaraCliTemplate < Formula
  desc "Scaffold new Rust CLI projects from the rara-cli-template"
  homepage "https://github.com/rararulab/cli-template"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/rararulab/cli-template/releases/download/v0.1.0/rara-cli-template-aarch64-apple-darwin.tar.xz"
    sha256 "3b91f3b2200a23039efbf80e29611e585d6a36163e7cc92ad734863e50bd60a8"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/rararulab/cli-template/releases/download/v0.1.0/rara-cli-template-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "05949a72abd7f3ef4a73b0c49917b50a33b03c4355f181ccbdd238b91673e341"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rara-cli-template" if OS.mac? && Hardware::CPU.arm?
    bin.install "rara-cli-template" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
