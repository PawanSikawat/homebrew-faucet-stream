class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://faucet-hq.github.io/faucet-stream/"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.7.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3d11de477ddcec340f05075e107e070d94c61d6bd9ef012428657093ceef8a08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.7.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "963c239cc7e43c1abf685d2067b210c2b1c76604188a68112490cd62538a107e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.7.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f26c0a57913c1b9f83d3f3d42678f827b7c84567a57782bfbbab2a68529b9629"
    end
    if Hardware::CPU.intel?
      url "https://github.com/faucet-hq/faucet-stream/releases/download/faucet-cli-v1.7.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "031d5a0bab1a5f32b594fe34a0390f84c32367046c3f2669625020d4f1d7ff33"
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
