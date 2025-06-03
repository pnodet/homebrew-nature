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
      bin.install "bin/nature" => "nature-bin"
      bin.install "bin/nls" if File.exist?("bin/nls")
      bin.install "bin/npkg" if File.exist?("bin/npkg")

      # Install standard library and lib directory
      lib.install "std"
      lib.install "lib"

      # Install license and version files
      doc.install "LICENSE-APACHE", "LICENSE-MIT"
      lib.install "VERSION" if File.exist?("VERSION")
    end

    # Create a wrapper script that sets up the environment properly
    (bin/"nature").write <<~EOS
      #!/bin/bash
      export NATURE_ROOT="#{lib}"
      exec "#{bin}/nature-bin" "$@"
    EOS
    chmod 0755, bin/"nature"
  end

  def caveats
    <<~EOS
      Nature has been installed successfully.

      The NATURE_ROOT environment variable is automatically set by the wrapper.
      You can now use nature directly with:
        nature build main.n

      IMPORTANT - LINKER CONFIGURATION:
      If you have Anaconda or other development environments installed, you may
      encounter linker errors. In this case, specify the system linker explicitly:
        nature build --ld /usr/bin/ld main.n

      For projects requiring specific frameworks (like raylib):
        nature build --ld /usr/bin/ld --ldflags '-framework IOKit -framework Cocoa' main.n

      The standard library is located at:
        #{lib}/std

      MANUAL CONFIGURATION (if needed):
      If you prefer to set the environment manually:
        export NATURE_ROOT=#{lib}
        #{bin}/nature-bin build main.n
    EOS
  end

  test do
    # Test the wrapper script
    system bin/"nature", "--version"
  end
end
