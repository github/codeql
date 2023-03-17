/**
 * Provides classes modeling security-relevant aspects of the `log` package.
 */

import go

/** Provides models of commonly used functions in the `log` package. */
module Log {
  private class LogFunction extends Function {
    LogFunction() {
      exists(string fn | fn.matches(["Fatal%", "Panic%", "Print%"]) |
        this.hasQualifiedName("log", fn)
        or
        this.(Method).hasQualifiedName("log", "Logger", fn)
      )
    }
  }

  private class LogFormatter extends StringOps::Formatting::Range instanceof LogFunction {
    LogFormatter() { this.getName().matches("%f") }

    override int getFormatStringIndex() { result = 0 }

    override int getFirstFormattedParameterIndex() { result = 1 }
  }

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() { this = any(LogFunction f).getACall() }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  /** A fatal log function, which calls `os.Exit`. */
  private class FatalLogFunction extends Function {
    FatalLogFunction() {
      exists(string fn | fn.matches("Fatal%") | this.hasQualifiedName("log", fn))
    }

    override predicate mayReturnNormally() { none() }
  }

  // These models are not implemented using Models-as-Data because they represent reverse flow.
  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func New(out io.Writer, prefix string, flag int) *Logger
      this.hasQualifiedName("log", "New") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
