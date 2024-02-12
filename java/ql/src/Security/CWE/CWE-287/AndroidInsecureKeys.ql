/**
 * @name Insecurely generated keys for local authentication
 * @description Keys used for local biometric authentication should be generated with secure parameters.
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
