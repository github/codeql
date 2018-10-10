/**
 * @name Useless defensive code
 * @description If the situation some defensive code guards against never
 *              happens, then the defensive code is not needed.
 * @kind problem
 * @problem.severity recommendation
 * @id js/useless-defensive-code
 * @tags correctness
 *       external/cwe/cwe-570
 *       external/cwe/cwe-571
 * @precision very-high
 */

import javascript
import semmle.javascript.DefensiveProgramming

from DefensiveExpression e, boolean cv
where e.getTheTestResult() = cv and
      // whitelist
      not (
        // module environment detection
        exists (VarAccess access, string name |
          name = "exports" or name = "module" |
          e.asExpr().(Internal::TypeofUndefinedTest).getOperand() = access and
          access.getName() = name and
          not exists (access.getVariable().getADeclaration())
        )
        or
        // too benign in practice
        e instanceof Internal::DefensiveInit
      )
select e, "This guard always evaluates to " + cv + "."
