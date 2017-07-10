class Libpoly < Formula
  desc "C library for manipulating polynomials"
  homepage "https://github.com/SRI-CSL/libpoly"
  url "https://github.com/SRI-CSL/libpoly/archive/v0.1.3.tar.gz"
  sha256 "5378c05c1b534875d23883840db75aa3cdde6351e66d02aeb7dfd6585001a959"

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "..", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <poly/rational.h>
    #include <stdlib.h>

    int main(int argc, char *argv[]) {
        lp_rational_t *q;
        q = (lp_rational_t*)malloc(sizeof(lp_rational_t));
        lp_rational_construct_from_double(q, 5);
        printf("%lf", lp_rational_to_double(q));
        return 0;
    }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/poly", "-lpoly"
    assert_match "5.000000", shell_output("./test")
  end
end
