/**
 * @name Insecure local authentication
 * @description Local authentication that does not make use of a `CryptoObject` can be bypassed.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.4
 * @precision high
 * @id java/android/insecure-local-authentication
 * @tags security
 *       external/cwe/cwe-287
 */

import java
import semmle.code.java.security.AndroidLocalAuthQuery

from AuthenticationSuccessCallback c
where not exists(c.getAResultUse())
select c, "This authentication callback does not use its result for a cryptographic operation."
