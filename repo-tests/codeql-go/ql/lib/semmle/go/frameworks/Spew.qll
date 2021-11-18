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

  private class SpewCall extends LoggerCall::Range, DataFlow::CallNode {
    int firstPrintedArg;

    SpewCall() {
      exists(string fn |
        fn in ["Dump", "Errorf", "Print", "Printf", "Println"] and firstPrintedArg = 0
        or
        fn in ["Fdump", "Fprint", "Fprintf", "Fprintln"] and firstPrintedArg = 1
      |
        this.getTarget().hasQualifiedName(packagePath(), fn)
      )
    }

    override DataFlow::Node getAMessageComponent() {
      result = this.getArgument(any(int i | i >= firstPrintedArg))
    }
  }

  /** The `Sprint` function or one of its variants. */
  class Sprinter extends TaintTracking::FunctionModel {
    Sprinter() { this.hasQualifiedName(packagePath(), ["Sdump", "Sprint", "Sprintln", "Sprintf"]) }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }
}
