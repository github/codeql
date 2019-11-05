class MyClass {
  public method(x: Logger) {
    // Resolve based on type.
    x.method("Hello");

    // Resolve based on local dataflow.
    // Type information may degrade call graph precision.
    var newLogger: Logger;
    newLogger = new AngryLogger();
    (newLogger as Logger).method("I said, hello");
  }
}

class Logger {
  public method(x: string) {
    console.log(x);
  }
}

class AngryLogger extends Logger {
  public method(x: string) {
    console.log(x.toUpperCase() + "!!");
  }
}
