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
    int firstPrintedArg;

    GlogCall() {
      exists(string pkg, Function f, string fn, string level |
        pkg = package(["github.com/golang/glog", "gopkg.in/glog", "k8s.io/klog"], "") and
        level = ["Error", "Exit", "Fatal", "Info", "Warning"] and
        (
          fn = level + ["", "f", "ln"] and firstPrintedArg = 0
          or
          fn = level + "Depth" and firstPrintedArg = 1
        ) and
        this = f.getACall()
      |
        f.hasQualifiedName(pkg, fn)
        or
        f.(Method).hasQualifiedName(pkg, "Verbose", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() {
      result = this.getArgument(any(int i | i >= firstPrintedArg))
    }
  }
}
