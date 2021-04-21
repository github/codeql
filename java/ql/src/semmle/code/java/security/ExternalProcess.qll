/* Definitions related to external processes. */
import semmle.code.java.Member
import semmle.code.java.JDK
import semmle.code.java.frameworks.apache.Exec

/**
 * A method that executes a command.
 */
abstract class ExecCallable extends Callable {
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
