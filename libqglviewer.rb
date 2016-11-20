class Libqglviewer < Formula
  desc "C++ Qt library to create OpenGL 3D viewers"
  homepage "http://www.libqglviewer.com/"
  url "http://www.libqglviewer.com/src/libQGLViewer-2.6.4.tar.gz"
  sha256 "53daefd7981a3ff7719ee55c368226807791d916ed988dde0aa0eac89686389d"

  head "https://github.com/GillesDebunne/libQGLViewer.git"

  option :universal

  depends_on "qt5"

  def install
    args = %W[
      PREFIX=#{prefix}
      DOC_DIR=#{doc}
    ]
    args << "CONFIG += x86 x86_64" if build.universal?

    cd "QGLViewer" do
      system "qmake", *args
      system "make", "install"
    end
  end
end
