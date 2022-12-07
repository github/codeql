/**
 * @name Use of `Kernel.open` or `IO.read` with a non-constant value
 * @description Using `Kernel.open` or `IO.read` may allow a malicious
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
import codeql.ruby.ast.Literal

from AmbiguousPathCall call
where
  // there is not a constant string argument
  not exists(call.getPathArgument().getConstantValue()) and
  // if it's a format string, then the first argument is not a constant string
  not call.getPathArgument().getALocalSource().asExpr().getExpr().(StringLiteral).getComponent(0)
    instanceof StringTextComponent
select call,
  "Call to " + call.getName() + " with a non-constant value. Consider replacing it with " +
    call.getReplacement() + "."
