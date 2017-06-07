class Yices < Formula
  desc "The Yices SMT Solver"
  homepage "http://yices.csl.sri.com/"
  url "http://yices.csl.sri.com/cgi-bin/yices2-newnewlicense.cgi?file=yices-2.5.2-src.tar.gz"
  sha256 "7241cd3104b846a0f14f5edfd69b34a8378dfe50ac08b362ed86b296f05d4873"

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "gperf"
  depends_on "gmp"

  def install
    system "autoconf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"lra.smt2").write <<-EOS.undent
      ;; QF_LRA = Quantifier-Free Linear Real Arithemtic
      (set-logic QF_LRA)
      ;; Declare variables x, y
      (declare-fun x () Real)
      (declare-fun y () Real)
      ;; Find solution to (x + y > 0), ((x < 0) || (y < 0))
      (assert (> (+ x y) 0))
      (assert (or (< x 0) (< y 0)))
      ;; Run a satisfiability check
      (check-sat)
      ;; Print the model
      (get-model)
    EOS

    assert_match "sat\n(= x 2)\n(= y (- 1))\n", shell_output("#{bin}/yices-smt2 lra.smt2")
  end
end
