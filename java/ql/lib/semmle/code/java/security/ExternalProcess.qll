/** Definitions related to external processes. */

import semmle.code.java.Member
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.security.CommandLineQuery

/**
 * An expression used as an argument to a call that executes an external command. For calls to
 * varargs method calls, this only includes the first argument, which will be the command
 * to be executed.
 */
class ArgumentToExec extends Expr {
  ArgumentToExec() { argumentToExec(this, _) }
}

/**
 * Holds if `e` is an expression used as an argument to a call that executes an external command.
 * For calls to varargs method calls, this only includes the first argument, which will be the command
 * to be executed.
 */
predicate argumentToExec(Expr e, CommandInjectionSink s) {
  s.asExpr() = e
  or
  e.(Argument).isNthVararg(0) and
  s.(DataFlow::ImplicitVarargsArray).getCall() = e.(Argument).getCall()
}

/**
 * An `ArgumentToExec` of type `String`.
 */
class StringArgumentToExec extends ArgumentToExec {
  StringArgumentToExec() { this.getType() instanceof TypeString }
}
