/**
 * @name Use of eval
 * @description Using `eval()` to evaluate arbitrary strings as PHP code
 *              is a security risk and should be avoided.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id php/eval-use
 * @tags security
 *       maintainability
 *       external/cwe/cwe-095
 */

import codeql.php.AST

from FunctionCallExpr call
where call.getFunctionName() = "eval"
select call, "Avoid using eval()."
