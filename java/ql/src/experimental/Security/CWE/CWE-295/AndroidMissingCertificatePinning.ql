/**
 * @name Android Missing Certificate Pinning
 * @description Network communication should use certificate pinning.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/missingcertificate-pinning
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.security.AndroidCertificatePinningQuery

from DataFlow::Node node
where missingPinning(node)
select node, "This network call does not implement certificate pinning."
