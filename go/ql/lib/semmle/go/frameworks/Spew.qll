/**
 * Provides models of commonly used functions in the `github.com/davecgh/go-spew/spew` package.
 */

import go

/**
 * Provides models of commonly used functions in the `github.com/davecgh/go-spew/spew` package.
 */
module Spew {
  /** Gets the package path `github.com/davecgh/go-spew/spew`. */
  private string packagePath() { result = package("github.com/davecgh/go-spew", "spew") }

  private class SpewFunction extends Function {
    int firstPrintedArg;

    SpewFunction() {
      exists(string fn |
        fn in ["Dump", "Errorf", "Print", "Printf", "Println"] and firstPrintedArg = 0
        or
        fn in ["Fdump", "Fprint", "Fprintf", "Fprintln"] and firstPrintedArg = 1
      |
        this.hasQualifiedName(packagePath(), fn)
      )
    }

    int getFirstPrintedArg() { result = firstPrintedArg }
  }

  private class StringFormatter extends StringOps::Formatting::Range instanceof SpewFunction {
    StringFormatter() { this.getName().matches("%f") }

    override int getFormatStringIndex() { result = super.getFirstPrintedArg() }
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  /** The `Sprint` function or one of its variants. */
  class Sprinter extends TaintTracking::FunctionModel {
    Sprinter() { this.hasQualifiedName(packagePath(), ["Sdump", "Sprint", "Sprintln", "Sprintf"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }
}
