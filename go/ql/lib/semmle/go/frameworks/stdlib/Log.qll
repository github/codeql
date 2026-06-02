/**
 * Provides classes modeling security-relevant aspects of the `log` package.
 */
overlay[local?]
module;

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
    LogFormatter() { this.getName() = ["Fatalf", "Panicf", "Printf", "Panic", "Panicf", "Panicln"] }

    override int getFormatStringIndex() { result = 0 }
  }

  /** A fatal log function, which calls `os.Exit`. */
  private class FatalLogFunction extends Function {
    FatalLogFunction() {
      exists(string fn | fn = ["Fatal", "Fatalf", "Fatalln"] |
        this.hasQualifiedName("log", fn)
        or
        this.(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    override predicate mayReturnNormally() { none() }
  }

  /** A log function which must panic. */
  private class PanicLogFunction extends Function {
    PanicLogFunction() {
      exists(string fn | fn = ["Panic", "Panicf", "Panicln"] |
        this.hasQualifiedName("log", fn)
        or
        this.(Method).hasQualifiedName("log", "Logger", fn)
      )
    }

    override predicate mustPanic() { any() }
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
