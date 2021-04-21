/* Definitions related to external processes. */
import semmle.code.java.Member
import semmle.code.java.JDK
import semmle.code.java.frameworks.apache.Exec

/**
 * A method that executes a command.
 */
abstract class ExecMethod extends Method { }

/**
 * An expression used as an argument to a call that executes an external command. For calls to
 * varargs method calls, this only includes the first argument, which will be the command
 * to be executed.
 */
class ArgumentToExec extends Expr {
  ArgumentToExec() {
    exists(MethodAccess execCall, ExecMethod method |
      execCall.getArgument(0) = this and
      method = execCall.getMethod()
    )
    or
    exists(ConstructorCall expr, Constructor cons |
      expr.getConstructor() = cons and
      cons.getDeclaringType().hasQualifiedName("java.lang", "ProcessBuilder") and
      expr.getArgument(0) = this
    )
  }
}

/**
 * An `ArgumentToExec` of type `String`.
 */
class StringArgumentToExec extends ArgumentToExec {
  StringArgumentToExec() { this.getType() instanceof TypeString }
}
