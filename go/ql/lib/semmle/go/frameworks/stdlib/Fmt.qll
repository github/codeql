/**
 * Provides classes modeling security-relevant aspects of the `fmt` package.
 */

import go

// Some TaintTracking::FunctionModel subclasses remain because varargs functions don't work with Models-as-Data sumamries yet.
/** Provides models of commonly used functions in the `fmt` package. */
module Fmt {
  /**
   * DEPRECATED: Use AppenderOrSprinterFunc instead.
   *
   * The `Sprint` or `Append` functions or one of their variants.
   */
  deprecated class AppenderOrSprinter extends TaintTracking::FunctionModel {
    AppenderOrSprinter() {
      this.hasQualifiedName("fmt",
        ["Append", "Appendf", "Appendln", "Sprint", "Sprintf", "Sprintln"])
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** The `Sprint` or `Append` functions or one of their variants. */
  class AppenderOrSprinterFunc extends Function {
    AppenderOrSprinterFunc() {
      this.hasQualifiedName("fmt",
        ["Append", "Appendf", "Appendln", "Sprint", "Sprintf", "Sprintln"])
    }
  }

  /** The `Sprint` function or one of its variants. */
  class Sprinter extends AppenderOrSprinterFunc {
    Sprinter() { this.getName() = ["Sprint", "Sprintf", "Sprintln"] }
  }

  /** The `Print` function or one of its variants. */
  class Printer extends Function {
    Printer() { this.hasQualifiedName("fmt", ["Print", "Printf", "Println"]) }
  }

  /** A call to `Print` or similar. */
  private class PrintCall extends LoggerCall::Range, DataFlow::CallNode {
    PrintCall() { this.getTarget() instanceof Printer }

    override DataFlow::Node getAMessageComponent() { result = this.getASyntacticArgument() }
  }

  /** The `Fprint` function or one of its variants. */
  private class Fprinter extends TaintTracking::FunctionModel {
    Fprinter() {
      // signature: func Fprint(w io.Writer, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fprint")
      or
      // signature: func Fprintf(w io.Writer, format string, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fprintf")
      or
      // signature: func Fprintln(w io.Writer, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fprintln")
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input.isParameter(any(int i | i > 0)) and output.isParameter(0)
    }
  }

  private class FmtStringFormatter extends StringOps::Formatting::Range {
    int argOffset;

    FmtStringFormatter() {
      exists(string fname |
        this.hasQualifiedName("fmt", fname) and
        (
          fname = ["Printf", "Sprintf"] and argOffset = 0
          or
          fname = "Fprintf" and argOffset = 1
        )
      )
    }

    override int getFormatStringIndex() { result = argOffset }
  }

  /** The `Sscan` function or one of its variants. */
  private class Sscanner extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    Sscanner() {
      // signature: func Sscan(str string, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Sscan") and
      (inp.isParameter(0) and outp.isParameter(any(int i | i >= 1)))
      or
      // signature: func Sscanf(str string, format string, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Sscanf") and
      (inp.isParameter([0, 1]) and outp.isParameter(any(int i | i >= 2)))
      or
      // signature: func Sscanln(str string, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Sscanln") and
      (inp.isParameter(0) and outp.isParameter(any(int i | i >= 1)))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  /** The `Scan` function or one of its variants, all of which read from `os.Stdin`. */
  class Scanner extends Function {
    Scanner() { this.hasQualifiedName("fmt", ["Scan", "Scanf", "Scanln"]) }
  }

  /**
   * The `Fscan` function or one of its variants,
   * all of which read from a specified `io.Reader`.
   */
  class FScanner extends Function {
    FScanner() { this.hasQualifiedName("fmt", ["Fscan", "Fscanf", "Fscanln"]) }

    /**
     * Gets the node corresponding to the `io.Reader`
     * argument provided in the call.
     */
    FunctionInput getReader() { result.isParameter(0) }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func Errorf(format string, a ...interface{}) error
      this.hasQualifiedName("fmt", "Errorf") and
      (inp.isParameter(_) and outp.isResult())
      or
      // signature: func Fscan(r io.Reader, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fscan") and
      (inp.isParameter(0) and outp.isParameter(any(int i | i >= 1)))
      or
      // signature: func Fscanf(r io.Reader, format string, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fscanf") and
      (inp.isParameter([0, 1]) and outp.isParameter(any(int i | i >= 2)))
      or
      // signature: func Fscanln(r io.Reader, a ...interface{}) (n int, err error)
      this.hasQualifiedName("fmt", "Fscanln") and
      (inp.isParameter(0) and outp.isParameter(any(int i | i >= 1)))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
