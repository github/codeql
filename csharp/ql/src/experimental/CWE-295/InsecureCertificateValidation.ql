/**
 * @name Unsafe `CertificateValidationCallback` use.
 * @description Using a `CertificateValidationCallback` that always returns `true` is insecure, as it allows any certificate to be accepted as valid.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id cs/unsafe-certificate-validation
 * @tags security
 *       external/cwe/cwe-295
 *       external/cwe/cwe-297
 */

import csharp
import DataFlow
import InsecureCertificateValidationQuery
import InsecureCertificateValidation::PathGraph

from InsecureCertificateValidation::PathNode source, InsecureCertificateValidation::PathNode sink
where InsecureCertificateValidation::flowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ that is defined $@ and accepts any certificate as valid, is used here.", sink,
  "This certificate callback", source, "here"
