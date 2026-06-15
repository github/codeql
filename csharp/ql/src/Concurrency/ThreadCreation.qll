/**
 * A library for reasoning about thread creation events in C#.
 */

import Concurrency

/**
 * A method or constructor which starts a thread based on one of its parameters.
 */
class ThreadStartingCallable extends Callable {
  ThreadStartingCallable() {
    this.(Constructor).getDeclaringType().hasFullyQualifiedName("System.Threading.Tasks", "Task")
    or
    this.(Method).hasFullyQualifiedName("System.Threading.Tasks", "Task", "Run")
    or
    this.(Constructor).getDeclaringType().hasFullyQualifiedName("System.Threading", "Thread")
    or
    this.(Method).hasFullyQualifiedName("System.Threading", "Thread", "Start")
    or
    exists(string name |
      this.(Constructor).getDeclaringType().hasFullyQualifiedName("System.Threading.Tasks", name) and
      name.matches("Task<%>")
    )
  }
}

/**
 * A callable which may be the starting point of a concurrently executing thread.
 * This is an abstract class; subclasses provide different ways of recognizing
 * such entry points.
 */
abstract class ConcurrentEntryPoint extends Callable { }

/**
 * Methods annotated with the `async` keyword are concurrent entry points.
 */
class AsyncMethod extends ConcurrentEntryPoint {
  AsyncMethod() { this.(Modifiable).isAsync() }
}

/**
 * Lambdas or methods passed into the thread or task creation library functions
 * will execute at the beginning of a new thread.
 */
class LibraryTask extends ConcurrentEntryPoint {
  LibraryTask() {
    exists(Call c, Expr arg |
      c.getTarget() instanceof ThreadStartingCallable and
      arg = c.getAnArgument()
    |
      this = arg or
      this = arg.(DelegateCreation).getArgument().(CallableAccess).getTarget()
    )
  }
}

/**
 * A method which takes some measures to control concurrent execution can be taken
 * as an indication that the code is expected to run concurrently.
 */
class ConcurrencyAwareMethod extends ConcurrentEntryPoint {
  ConcurrencyAwareMethod() {
    this = any(LockStmt l).getEnclosingCallable() or
    this = any(LockingCall c).getEnclosingCallable()
  }
}
