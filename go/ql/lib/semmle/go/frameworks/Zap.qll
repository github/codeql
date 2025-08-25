/**
 * Provides models of commonly used functions in the `go.uber.org/zap` package.
 */

import go

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
  }

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
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
