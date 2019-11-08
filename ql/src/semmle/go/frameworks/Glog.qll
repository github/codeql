/** Provides models of commonly used functions in the `github.com/golang/glog` package. */

import go

module Glog {
  private class GlogCall extends LoggerCall::Range, DataFlow::CallNode {
    GlogCall() {
      exists(string fn |
        fn.regexpMatch("Error(|f|ln)")
        or
        fn.regexpMatch("Exit(|f|ln)")
        or
        fn.regexpMatch("Fatal(|f|ln)")
        or
        fn.regexpMatch("Info(|f|ln)")
        or
        fn.regexpMatch("Warning(|f|ln)")
      |
        this.getTarget().hasQualifiedName("github.com/golang/glog", fn)
        or
        this.getTarget().(Method).hasQualifiedName("github.com/golang/glog", "Verbose", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}
