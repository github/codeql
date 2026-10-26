class Job implements Runnable {
  public void run() {
    /* ... */
  }
}

/**
 * A class that subclasses `java.lang.Thread` and inherits its `.run()` method.
 */
class AnotherThread1 extends Thread {
  AnotherThread1(Runnable runnable) {
    super(runnable);
  }
}

/**
 * A class that directly subclasses `java.lang.Thread` and overrides its
 * `.run()` method.
 */
class AnotherThread2 extends Thread {
  AnotherThread2(Runnable runnable) {
    super(runnable);
  }

  /**
   * An overriding definition of `Thread.run`.
   */
  @Override
  public void run() {
    super.run(); // COMPLIANT: called within a `run` method
  }
}

/**
 * A class that indirectly subclasses `java.lang.Thread` by subclassing
 * `AnotherThread1` and inherits its `.run()`
 * method.
 */
class YetAnotherThread1 extends AnotherThread1 {
  YetAnotherThread1(Runnable runnable) {
    super(runnable);
  }
}

/**
 * A class that indirectly subclasses `java.lang.Thread` by subclassing
 * `AnotherThread2` and overrides its `.run()`
 * method.
 */
class YetAnotherThread2 extends AnotherThread2 {
  YetAnotherThread2(Runnable runnable) {
    super(runnable);
  }

  /**
   * An overriding definition of `AnotherThread.run`.
   */
  @Override
  public void run() {
    super.run(); // COMPLIANT: called within a `run` method
  }
}

class ThreadExample {
  public void f() {
    Thread thread = new Thread(new Job());
    thread.run();  // $ Alert - `Thread.run()` called directly.
    thread.start(); // COMPLIANT: Thread started with `.start()`.

    AnotherThread1 anotherThread1 = new AnotherThread1(new Job());
    anotherThread1.run(); // $ Alert - Inherited `Thread.run()` called on its instance.
    anotherThread1.start(); // COMPLIANT: Inherited `Thread.start()` used to start the thread.

    AnotherThread2 anotherThread2 = new AnotherThread2(new Job());
    anotherThread2.run(); // $ Alert - Overriden `Thread.run()` called on its instance.
    anotherThread2.start(); // COMPLIANT: Overriden `Thread.start()` used to start the thread.

    YetAnotherThread1 yetAnotherThread1 = new YetAnotherThread1(new Job());
    yetAnotherThread1.run(); // $ Alert - Inherited `AnotherThread1.run()` called on its instance.
    yetAnotherThread1.start(); // COMPLIANT: Inherited `AnotherThread.start()` used to start the thread.

    YetAnotherThread2 yetAnotherThread2 = new YetAnotherThread2(new Job());
    yetAnotherThread2.run(); // $ Alert - Overriden `AnotherThread2.run()` called on its instance.
    yetAnotherThread2.start(); // COMPLIANT: Overriden `AnotherThread2.start()` used to start the thread.

    Runnable runnable = new Runnable() {
      public void run() {
        /* ... */ }
    };
    runnable.run(); // COMPLIANT: called on `Runnable` object.

    Job job = new Job();
    job.run(); // COMPLIANT: called on `Runnable` object.
  }
}
