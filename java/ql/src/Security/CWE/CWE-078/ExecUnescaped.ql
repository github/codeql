/**
 * @name Building a command line with string concatenation
 * @description Using concatenated strings in a command line is vulnerable to malicious
 *              insertion of special characters in the strings.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/concatenated-command-line
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.security.ExternalProcess
import semmle.code.java.security.CommandLineQuery

/**
 * Strings that are known to be sane by some simple local analysis. Such strings
 * do not need to be escaped, because the programmer can predict what the string
 * has in it.
 */
predicate saneString(Expr expr) {
  expr instanceof StringLiteral
  or
  expr instanceof NullLiteral
  or
  exists(Variable var | var.getAnAccess() = expr and exists(var.getAnAssignedValue()) |
    forall(Expr other | var.getAnAssignedValue() = other | saneString(other))
  )
}

predicate builtFromUncontrolledConcat(Expr expr) {
  exists(AddExpr concatExpr | concatExpr = expr |
    builtFromUncontrolledConcat(concatExpr.getAnOperand())
  )
  or
  exists(AddExpr concatExpr | concatExpr = expr |
    exists(Expr arg | arg = concatExpr.getAnOperand() | not saneString(arg))
  )
  or
  exists(Expr other | builtFromUncontrolledConcat(other) |
    exists(Variable var | var.getAnAssignedValue() = other and var.getAnAccess() = expr)
  )
}

from StringArgumentToExec argument
where
  builtFromUncontrolledConcat(argument) and
  not execTainted(_, _, argument)
select argument, "Command line is built with string concatenation."
