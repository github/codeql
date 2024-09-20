/**
 * Provides classes modeling security-relevant aspects of the `log` package.
 */

import go

/** Provides models of commonly used functions in the `log` package. */
module Log {
  private class LogFunction extends Function {
    int firstPrintedArg;

    LogFunction() {
      exists(string fn |
        fn =
          ["Fatal", "Fatalf", "Fatalln", "Panic", "Panicf", "Panicln", "Print", "Printf", "Println"] and
        firstPrintedArg = 0
        or
        fn = "Output" and firstPrintedArg = 1
      |
        this.hasQualifiedName("log", fn)
        or
        this.(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    int getFirstPrintedArg() { result = firstPrintedArg }
  }

  private class LogFormatter extends StringOps::Formatting::Range instanceof LogFunction {
    LogFormatter() { this.getName() = ["Fatalf", "Panicf", "Printf"] }

    override int getFormatStringIndex() { result = 0 }
  }

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogFunction target;

    LogCall() { this = target.getACall() }

    override DataFlow::Node getAMessageComponent() {
      result = this.getSyntacticArgument(any(int i | i >= target.getFirstPrintedArg()))
    }
  }

  /** A fatal log function, which calls `os.Exit`. */
  private class FatalLogFunction extends Function {
    FatalLogFunction() { this.hasQualifiedName("log", ["Fatal", "Fatalf", "Fatalln"]) }

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

  // These are expressed using TaintTracking::FunctionModel because varargs functions don't work with Models-as-Data sumamries yet.
  private class MethodModels extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    MethodModels() {
      // signature: func (*Logger) Fatal(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatal") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Fatalf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatalf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Fatalln(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Fatalln") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Panic(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panic") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Panicf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panicf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Panicln(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Panicln") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Print(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Print") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Printf(format string, v ...interface{})
      this.hasQualifiedName("log", "Logger", "Printf") and
      (inp.isParameter(_) and outp.isReceiver())
      or
      // signature: func (*Logger) Println(v ...interface{})
      this.hasQualifiedName("log", "Logger", "Println") and
      (inp.isParameter(_) and outp.isReceiver())
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
