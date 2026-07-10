class FaucetCli < Formula
  desc "Config-driven CLI runner for faucet-stream pipelines (YAML / JSON, Meltano-style)"
  homepage "https://pawansikawat.github.io/faucet-stream/"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.4.0/faucet-cli-aarch64-apple-darwin.tar.xz"
      sha256 "9ad260ab7e5d7228afb56e3faeb27ee9cdc89e62333f951ee05bb8f8779ddc0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.4.0/faucet-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4f43dc3745bb96be6abe20a7cac680d0080aa7e8623743712a8aa194ce4de935"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.4.0/faucet-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "323b45087940bc434a66794ff4e5e7480d7f17835bc1c13f904231a878773f1a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PawanSikawat/faucet-stream/releases/download/faucet-cli-v1.4.0/faucet-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f3925257c891c13721ccc037639a7949965d828202bc863ad820eda466df1fa"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "faucet"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "faucet"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "faucet"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "faucet"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
