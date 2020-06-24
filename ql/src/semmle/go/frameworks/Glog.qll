/**
 * Provides models of commonly used functions in the `github.com/golang/glog` and `k8s.io/klog`
 * packages.
 */

import go

/**
 * Provides models of commonly used functions in the `github.com/golang/glog` packages and its
 * forks.
 */
module Glog {
  private class GlogCall extends LoggerCall::Range, DataFlow::CallNode {
    GlogCall() {
      exists(string pkg, Function f, string fn |
        pkg = package(["github.com/golang/glog", "gopkg.in/glog", "k8s.io/klog"], "") and
        fn.regexpMatch("(Error|Exit|Fatal|Info|Warning)(|f|ln)") and
        this = f.getACall()
      |
        f.hasQualifiedName(pkg, fn)
        or
        f.(Method).hasQualifiedName(pkg, "Verbose", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}
