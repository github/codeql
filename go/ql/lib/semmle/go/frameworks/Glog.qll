/**
 * Provides models of commonly used functions in the `github.com/golang/glog` and `k8s.io/klog`
 * packages.
 */
overlay[local?]
module;

import go

/**
 * Provides models of commonly used functions in the `github.com/golang/glog` packages and its
 * forks.
 */
module Glog {
  string packagePath() {
    result =
      package([
          "github.com/golang/glog", "gopkg.in/glog", "k8s.io/klog", "github.com/barakmich/glog"
        ], "")
  }

  private class GlogFunction extends Function {
    int firstPrintedArg;
    string format;
    string level;

    GlogFunction() {
      exists(string pkg, string context, int nContextArgs, string depth, int nDepthArgs, string fn |
        pkg = packagePath() and
        level = ["Error", "Exit", "Fatal", "Info", "Warning"] and
        (
          context = "" and nContextArgs = 0
          or
          context = "Context" and nContextArgs = 1
        ) and
        (
          depth = "" and nDepthArgs = 0
          or
          depth = "Depth" and nDepthArgs = 1
        ) and
        format = ["", "f", "ln"] and
        (
          fn = level + context + depth + format and
          firstPrintedArg = nContextArgs + nDepthArgs
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

    predicate formatter() { format = "f" }

    override predicate mayReturnNormally() { level != "Fatal" and level != "Exit" }
  }

  private class StringFormatter extends StringOps::Formatting::Range instanceof GlogFunction {
    StringFormatter() { this.formatter() }

    override int getFormatStringIndex() { result = super.getFirstPrintedArg() }
  }
}
