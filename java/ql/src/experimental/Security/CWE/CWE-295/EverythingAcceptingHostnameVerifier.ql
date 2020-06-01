/**
 * @name Disabled hostname verification
 * @description Accepting any certificate as valid for a host allows an attacker to perform a man-in-the-middle attack.
 * @kind alert
 * @problem.severity error
 * @precision high
 * @id java/everything-accepting-hostname-verifier
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import HostnameValidation

from AlwaysAcceptingVerifyMethod m
where not m.getDeclaringType() instanceof TestClass
select m, "$@ accepts any certificate as valid for a host.", m, "This method"
