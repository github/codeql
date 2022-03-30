/* Definitions related to external processes. */
import semmle.code.java.Member

private module Instances {
  private import semmle.code.java.JDK
  private import semmle.code.java.frameworks.apache.Exec
}

/**
 * A callable that executes a command.
 */
abstract class ExecCallable extends Callable {
  /**
   * Gets the index of an argument that will be part of the command that is executed.
   */
  abstract int getAnExecutedArgument();
}

/**
 * An expression used as an argument to a call that executes an external command. For calls to
 * varargs method calls, this only includes the first argument, which will be the command
 * to be executed.
 */
class ArgumentToExec extends Expr {
  ArgumentToExec() {
    exists(Call execCall, ExecCallable execCallable, int i |
      execCall.getArgument(pragma[only_bind_into](i)) = this and
      execCallable = execCall.getCallee() and
      i = execCallable.getAnExecutedArgument()
    )
  }
}

/**
 * An `ArgumentToExec` of type `String`.
 */
class StringArgumentToExec extends ArgumentToExec {
  StringArgumentToExec() { this.getType() instanceof TypeString }
}
