# J-D-001: Method call to `java.lang.Thread` or its subclasses may indicate a logical bug

Calling `run()` on `java.lang.Thread` or its subclasses may indicate misunderstanding on the programmer's part.

## Overview

The `java.lang` package provides class `Thread` for multithreading. This class provides a method named `start`, to begin executing its code in a separate thread, that calls another public API called `run`. However, directly calling `run` does not result in this multithreading behavior; rather, it executes the code in the context of the current thread.

Meanwhile, the argument of the call to the constructor of `Thread` should implement `java.lang.Runnable` which provides the public method `run`. Calling this method directly also does not create a separate thread, however, this rule does not prohibit such calls.

## Recommendation

For instances of `Thread` and its subclasses, use `start` instead of `run` to start the thread and begin executing the `run` method of the `Runnable` instance used to construct the instance of `Thread`.

## Example

The following example creates an instance of `java.lang.Thread` and intends to execute it by calling the `run` method on it instead of `start`.

```java
import java.lang.Thread;
import java.lang.Runnable;

class Job implements Runnable {
  public void run() {
    /* ... */
  }
}

class AnotherThread extends Thread {
  AnotherThread(Runnable runnable) {
    super(runnable);
  }

  public void run() {
    /* ... */
  }
}

class ThreadExample {
  public void f() {
    Thread thread = new Thread(new Job());
    thread.run();          // NON_COMPLIANT
    thread.start();        // COMPLIANT

    AnotherThread anotherThread = new AnotherThread(new Job());
    anotherThread.run();   // NON_COMPLIANT
    anotherThread.start(); // COMPLIANT

    Job job = new Job();
    job.run();             // COMPLIANT
  }
}
```

## References

- Oracle: [Documentation of java.lang.Thread](https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html).
- Oracle: [Documentation of java.lang.Runnable](https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html).
