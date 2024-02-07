/**
 * @name Insecurely generated keys for local authentication
 * @description Keys used for local biometric authentication should be generated with secure parameters.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision medium
 * @id java/android/insecure-local-key-gen
 * @tags security
 *       external/cwe/cwe-287
 */

import java
import semmle.code.java.security.AndroidLocalAuthQuery

/** Holds if the application contains an instance of a key being used for local biometric authentication. */
predicate usesLocalAuth() { exists(AuthenticationSuccessCallback cb | exists(cb.getAResultUse())) }

from InsecureBiometricKeyParam call
where usesLocalAuth()
select call, "This key is not secure for biometric authentication."
