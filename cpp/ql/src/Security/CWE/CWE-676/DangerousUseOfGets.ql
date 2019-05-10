/**
 * @name Use of dangerous function 'gets'
 * @description The standard library 'gets' function is dangerous and should not be used.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id cpp/potentially-dangerous-function
 * @tags reliability
 *       security
 *       external/cwe/cwe-242
 */
import cpp

from FunctionCall call, Function target
where
  call.getTarget() = target and
  target.getQualifiedName() = "gets"
select call, "gets does not guard against buffer overflow"
