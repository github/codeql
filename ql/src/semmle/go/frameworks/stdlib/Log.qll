/**
 * Provides classes modeling security-relevant aspects of the `log` package.
 */

import go

/** Provides models of commonly used functions in the `log` package. */
module Log {
  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() {
      exists(string fn |
        fn.matches("Fatal%")
        or
        fn.matches("Panic%")
        or
        fn.matches("Print%")
      |
        this.getTarget().hasQualifiedName("log", fn)
        or
        this.getTarget().(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  /** A fatal log function, which calls `os.Exit`. */
  private class FatalLogFunction extends Function {
    FatalLogFunction() { exists(string fn | fn.matches("Fatal%") | hasQualifiedName("log", fn)) }

    override predicate mayReturnNormally() { none() }
  }

  private class FunctionModels extends TaintTracking::FunctionModel {
    FunctionInput inp;
    FunctionOutput outp;

    FunctionModels() {
      // signature: func New(out io.Writer, prefix string, flag int) *Logger
      hasQualifiedName("log", "New") and
      (inp.isResult() and outp.isParameter(0))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Logger).Fatal(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatal") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Fatalf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatalf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Fatalln(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatalln") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Panic(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panic") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Panicf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panicf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Panicln(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panicln") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Print(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Print") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Printf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Printf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).Println(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Println") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger).SetOutput(w io.Writer)
      this.hasQualifiedName("log", "Logger", "SetOutput") and
      (inp.isReceiver() and outp.isParameter(0))
      or
      // signature: func (*Logger).SetPrefix(prefix string)
      this.hasQualifiedName("log", "Logger", "SetPrefix") and
      (inp.isParameter(0) and outp.isReceiver())
      or
      // signature: func (*Logger).Writer() io.Writer
      this.hasQualifiedName("log", "Logger", "Writer") and
      (inp.isResult() and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
