/**
 * Provides models of commonly used functions in the `go.uber.org/zap` package.
 */

import go
private import semmle.go.StringOps

/**
 * Provides models of commonly used functions in the `go.uber.org/zap` package.
 */
module Zap {
  /** Gets the package path `go.uber.org/zap`. */
  private string packagePath() { result = package("go.uber.org/zap", "") }

  /** Gets a suffix for a method on `zap.SugaredLogger`. */
  private string getSuffix() { result in ["", "f", "w"] }

  private class ZapFunction extends Method {
    ZapFunction() {
      exists(string fn | fn in ["DPanic", "Debug", "Error", "Fatal", "Info", "Panic", "Warn"] |
        this.hasQualifiedName(packagePath(), "Logger", fn)
        or
        this.hasQualifiedName(packagePath(), "SugaredLogger", fn + getSuffix())
      )
      or
      this.hasQualifiedName(packagePath(), "Logger", ["Named", "With", "WithOptions"])
      or
      this.hasQualifiedName(packagePath(), "SugaredLogger", ["Named", "With"])
    }
  }

  private class ZapFormatter extends StringOps::Formatting::Range instanceof ZapFunction {
    ZapFormatter() { this.getName().matches("%f") }

    override int getFormatStringIndex() { result = 0 }

    override int getFirstFormattedParameterIndex() { result = 1 }
  }

  /**
   * A call to a logger function in Zap.
   *
   * Functions which add data to be included the next time a direct logging
   * function is called are included.
   */
  private class ZapCall extends LoggerCall::Range, DataFlow::MethodCallNode {
    ZapCall() { this = any(ZapFunction f).getACall() }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  /** A function that creates a `Field` that can be logged. */
  class FieldFunction extends TaintTracking::FunctionModel {
    FieldFunction() {
      exists(string fn |
        fn in [
            "Any", "Binary", "ByteString", "ByteStrings", "Error", "Errors", "NamedError",
            "Reflect", "String", "Stringp", "Strings"
          ]
      |
        this.hasQualifiedName(packagePath(), fn)
      )
    }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** The function `Fields` that creates an `Option` that can be added to the logger out of `Field`s. */
  class FieldsFunction extends TaintTracking::FunctionModel {
    FieldsFunction() { this.hasQualifiedName(packagePath(), "Fields") }

    override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
      inp.isParameter(_) and outp.isResult()
    }
  }

  /** A Zap logging function which always panics. */
  private class FatalLogMethod extends Method {
    FatalLogMethod() {
      this.hasQualifiedName(packagePath(), "Logger", "Fatal")
      or
      this.hasQualifiedName(packagePath(), "SugaredLogger", "Fatal" + getSuffix())
    }

    override predicate mayReturnNormally() { none() }
  }

  /** A Zap logging function which always panics. */
  private class MustPanicLogMethod extends Method {
    MustPanicLogMethod() {
      this.hasQualifiedName(packagePath(), "Logger", "Panic")
      or
      this.hasQualifiedName(packagePath(), "SugaredLogger", "Panic" + getSuffix())
    }

    override predicate mustPanic() { any() }
  }
}
