class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://pawansikawat.github.io/faucet-stream/"
  version "1.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.6.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fed2f8e8240b30f8abf248ca1517017906105534b99f22ddcf9403f0f9687c4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.6.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "74b9c882260c0f0e6cd7558181c615264d10d7e25fa9674a5baa430f6741e7bc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.6.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ccc01490a10cf11040d66c053ae44213b963b8f4956be2223700e10b02f0f234"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.6.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6dab05341747b9e03d22c57c326ba1b91433249d7ff31b2ff73befddd5d15894"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "faucet" if OS.mac? && Hardware::CPU.arm?
    bin.install "faucet" if OS.mac? && Hardware::CPU.intel?
    bin.install "faucet" if OS.linux? && Hardware::CPU.arm?
    bin.install "faucet" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
