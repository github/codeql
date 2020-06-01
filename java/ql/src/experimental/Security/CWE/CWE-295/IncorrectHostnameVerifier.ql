/**
 * @name Incorrect hostname verification
 * @description Incorrectly verifying a hostname allows an attacker to perform a man-in-the-middle attack.
 * @kind alert
 * @problem.severity error
 * @precision high
 * @id java/incorrect-hostname-verifier
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import HostnameValidation

from IncorrectHostnameVerifyMethod m, Stmt dangerousStmt
where dangerousStmt = m.getADangerousStmt() and not m.getDeclaringType() instanceof TestClass
select dangerousStmt, "$@ incorrectly verifies the hostname.", dangerousStmt, "This statement"
