/**
 * @name Use of `Kernel.open` or `IO.read` or similar sinks with a non-constant value
 * @description Using `Kernel.open`, `IO.read`, `IO.write`, `IO.binread`, `IO.binwrite`,
 *              `IO.foreach`, `IO.readlines`, or `URI.open` may allow a malicious
 *              user to execute arbitrary system commands.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.8
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
import codeql.ruby.DataFlow

from AmbiguousPathCall call
where
  call.getNumberOfArguments() > 0 and
  not hasConstantPrefix(call.getPathArgument()) and
  not call.getPathArgument().getALocalSource() =
    API::getTopLevelMember("File").getAMethodCall("join")
select call,
  "Call to " + call.getName() + " with a non-constant value. Consider replacing it with " +
    call.getReplacement() + "."

predicate hasConstantPrefix(DataFlow::Node node) {
  hasConstantPrefix(node.getALocalSource())
  or
  // if it's a format string, then the first argument is not a constant string
  node.asExpr().getExpr().(StringlikeLiteral).getComponent(0) instanceof StringTextComponent
  or
  // it is not a constant string argument
  exists(node.getConstantValue())
  or
  // not a concatenation that starts with a constant string
  exists(DataFlow::ExprNode prefix |
    node.asExpr().getExpr().(AddExpr).getLeftOperand() = prefix.asExpr().getExpr() and
    hasConstantPrefix(prefix)
  )
  or
  // is a .freeze call on a constant string
  exists(DataFlow::CallNode call | node = call and call.getMethodName() = "freeze" |
    hasConstantPrefix(call.getReceiver())
  )
  or
  // is a constant read of a constant string
  exists(DataFlow::Node constant |
    constant.asExpr().getExpr() = node.asExpr().getExpr().(ConstantReadAccess).getValue() and
    hasConstantPrefix(constant)
  )
}
