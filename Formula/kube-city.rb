class KubeCity < Formula
  desc "A living isometric city of your Kubernetes cluster, in the browser or the terminal"
  homepage "https://github.com/braveadmin/kube-city"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.1.1/kube-city-aarch64-apple-darwin.tar.gz"
      sha256 "92add199e5f42e54bb8b16a5b8ff47086db91218b64b0109fc2bede9bafff63c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.1.1/kube-city-x86_64-apple-darwin.tar.gz"
      sha256 "15e1ada1582f2028ffec21376b36e36caf2811c2a83fb4e4edde78499c941e38"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.1.1/kube-city-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5fc27364b720a32cc6e2391b86b7071b2e2061c1e5d57d32005f5ec31fce5d84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/braveadmin/kube-city/releases/download/v0.1.1/kube-city-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6099a7b0f512ffa368e9a9958b31d89a3f82d85db34c6fc8f0a1a1425f4a4ce1"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kube-city"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kube-city"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kube-city"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kube-city"
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
