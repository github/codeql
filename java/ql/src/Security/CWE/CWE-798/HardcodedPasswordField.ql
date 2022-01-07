/**
 * @name Hard-coded password field
 * @description Hard-coding a password string may compromise security.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision low
 * @id java/hardcoded-password-field
 * @tags security
 *       external/cwe/cwe-798
 */

import java
import HardcodedCredentials

from PasswordVariable f, CompileTimeConstantExpr e
where
  f instanceof Field and
  f.getAnAssignedValue() = e and
  not e.(StringLiteral).getValue() = ""
select f, "Sensitive field is assigned a hard-coded $@.", e, "value"
