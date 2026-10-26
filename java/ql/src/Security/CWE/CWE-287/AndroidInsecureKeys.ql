/**
 * @name Insecurely generated keys for local authentication
 * @description Generation of keys with insecure parameters for local biometric authentication can allow attackers with physical access to bypass authentication checks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 4.4
 * @precision medium
 * @id java/android/insecure-local-key-gen
 * @tags security
 *       external/cwe/cwe-287
 */

import java
import semmle.code.java.security.AndroidLocalAuthQuery

from InsecureBiometricKeyParamCall call
where usesLocalAuth()
select call, "This key is not secure for biometric authentication."
