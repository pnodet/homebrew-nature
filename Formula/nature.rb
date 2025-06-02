class Nature < Formula
  desc "Modern systems programming language"
  homepage "https://nature-lang.org"
  url "https://github.com/nature-lang/nature/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9d8350f8b50dfe0823b034e36d1b797d64929541c6818ca1dae9a9d110b375ca"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "ninja" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release",
           "-DNATURE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build", "--target", "nature"

    if File.exist?("build/nature")
      bin.install "build/nature"
    elsif File.exist?("build/bin/nature")
      bin.install "build/bin/nature"
    else
      odie "Could not find nature binary after build"
    end
  end

  test do
    system bin/"nature", "--version"
  end
end
