import java.util.*;

public class A {
  static String source(String tag) { return tag; }

  static void sink(Object o) { }

  static class MyException extends RuntimeException {
    String msg;
    MyException(String msg) {
      this.msg = msg;
    }
  }

  static class MySubException extends MyException {
    MySubException(String msg) {
      super(msg);
    }
  }

  static class MyOtherException extends RuntimeException {
    String msg;
    MyOtherException(String msg) {
      this.msg = msg;
    }
  }

  void throwSome(int i) {
    if (i == 1) throw new MyException(source("my"));
    if (i == 2) throw new MySubException(source("sub"));
    try {
      if (i == 3) throw new MyOtherException(source("other"));
    } catch (ClassCastException e) {
    }
  }

  void foo(int i) {
    try {
      try {
        throwSome(i);
      } finally {
      }
    } catch (MySubException e) {
      sink(e.msg); // $ hasValueFlow=sub SPURIOUS: hasValueFlow=my
    } catch (MyException e) {
      sink(e.msg); // $ hasValueFlow=my SPURIOUS: hasValueFlow=sub
    } catch (MyOtherException e) {
      sink(e.msg); // $ hasValueFlow=other
    } catch (Exception e) {
      sink(((MyOtherException)e).msg); // $ SPURIOUS: hasValueFlow=other
    }
  }

  void throwArg(String msg) {
    throw new MyException(msg);
  }

  void catchSummary() {
    try {
      throwArg(source("arg"));
    } catch (MyException e) {
      sink(e.msg); // $ hasValueFlow=arg
    }
  }

  void runCallback(Runnable r) {
    r.run();
  }

  void catchCallback() {
    try {
      runCallback(() -> { throw new MyException(source("cb")); });
    } catch (MyException e) {
      sink(e.msg); // $ hasValueFlow=cb
    }

    try {
      List<String> l = Arrays.asList(new String[] { "s" });
      l.forEach(s -> { throw new MyException(source("cb2")); });
    } catch (MyException e) {
      sink(e.msg); // $ hasValueFlow=cb2
    }
  }

  void catchRuntimeException() {
    try {
      throw new RuntimeException(source("rte"));
    } catch (RuntimeException e) {
      sink(e.getMessage()); // $ hasValueFlow=rte
    }
  }
}
