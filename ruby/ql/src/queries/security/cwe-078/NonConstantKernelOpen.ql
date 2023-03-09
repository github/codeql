/**
 * @name Use of `Kernel.open` or `IO.read` or similar sinks with a non-constant value
 * @description Using `Kernel.open`, `IO.read`, `IO.write`, `IO.binread`, `IO.binwrite`,
 *              `IO.foreach`, `IO.readlines`, or `URI.open` may allow a malicious
 *              user to execute arbitrary system commands.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.5
 * @precision high
 * @id rb/non-constant-kernel-open
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 *       external/cwe/cwe-073
 */

import codeql.ruby.security.KernelOpenQuery
import codeql.ruby.AST
import codeql.ruby.ApiGraphs

from AmbiguousPathCall call
where
  not hasConstantPrefix(call.getPathArgument().getALocalSource().asExpr().getExpr()) and
  not call.getPathArgument().getALocalSource() =
    API::getTopLevelMember("File").getAMethodCall("join")
select call,
  "Call to " + call.getName() + " with a non-constant value. Consider replacing it with " +
    call.getReplacement() + "."

predicate hasConstantPrefix(Expr e) {
  // if it's a format string, then the first argument is not a constant string
  e.(StringlikeLiteral).getComponent(0) instanceof StringTextComponent
  or
  // it is not a constant string argument
  exists(e.getConstantValue())
  or
  // not a concatenation that starts with a constant string
  hasConstantPrefix(e.(AddExpr).getLeftOperand())
}
