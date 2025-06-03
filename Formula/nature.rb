class Nature < Formula
  desc "Modern systems programming language"
  homepage "https://nature-lang.org"
  license "Apache-2.0"

  if Hardware::CPU.arm?
    url "https://github.com/nature-lang/nature/releases/download/v0.5.0/nature-v0.5.0-darwin-arm64.tar.gz"
    sha256 "923b56ee44ce66e4c328142107f4ca9fb96755317c35baa44e5a05080206c9a3"
  else
    url "https://github.com/nature-lang/nature/releases/download/v0.5.0/nature-v0.5.0-darwin-amd64.tar.gz"
    sha256 "8558042c46bbe20245c094a413c4c2929af7fdb0fef816e3cae259aeaafdafe4"
  end

  def install
    # Check if we have a nature subdirectory or if files are in the root
    source_dir = Dir.exist?("nature") ? "nature" : "."

    Dir.chdir(source_dir) do
      # Install binaries
      bin.install "bin/nature"
      bin.install "bin/nls" if File.exist?("bin/nls")
      bin.install "bin/npkg" if File.exist?("bin/npkg")

      # Install standard library and lib directory
      lib.install "std"
      lib.install "lib"

      # Install license and version files
      doc.install "LICENSE-APACHE", "LICENSE-MIT"
      lib.install "VERSION" if File.exist?("VERSION")
    end
  end

  def caveats
    <<~EOS
      Nature has been installed successfully.

      You need to set the NATURE_ROOT environment variable to:
        export NATURE_ROOT=#{lib}

      To set this permanently in your shell:
        echo 'export NATURE_ROOT=#{lib}' >> ~/.zshrc

      Then you can use nature with:
        nature build main.n

      The standard library is located at:
        #{lib}/std
    EOS
  end

  test do
    # Set NATURE_ROOT for the test
    ENV["NATURE_ROOT"] = lib.to_s
    system bin/"nature", "--version"
  end
end
