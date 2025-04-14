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
  private class GlogFunction extends Function {
    int firstPrintedArg;

    GlogFunction() {
      exists(string pkg, string fn, string level |
        pkg = package(["github.com/golang/glog", "gopkg.in/glog", "k8s.io/klog"], "") and
        level = ["Error", "Exit", "Fatal", "Info", "Warning"] and
        (
          fn = level + ["", "f", "ln"] and firstPrintedArg = 0
          or
          fn = level + "Depth" and firstPrintedArg = 1
        )
      |
        this.hasQualifiedName(pkg, fn)
        or
        this.(Method).hasQualifiedName(pkg, "Verbose", fn)
      )
    }

    /**
     * Gets the index of the first argument that may be output, including a format string if one is present.
     */
    int getFirstPrintedArg() { result = firstPrintedArg }
  }

  private class StringFormatter extends StringOps::Formatting::Range instanceof GlogFunction {
    StringFormatter() { this.getName().matches("%f") }

    override int getFormatStringIndex() { result = super.getFirstPrintedArg() }
  }
}
