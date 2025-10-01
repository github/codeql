/**
 * @name Weak hashes
 * @description Finds uses of cryptographic hashing algorithms that are unapproved or otherwise weak.
 * @id java/quantum/slices/weak-hashes
 * @kind problem
 * @problem.severity error
 * @security.severity low
 * @precision high
 * @tags external/cwe/cwe-327
 */

import java
import experimental.quantum.Language

from Crypto::HashAlgorithmNode alg, string name, string msg
where
  name = alg.getAlgorithmName() and
  not name in ["SHA256", "SHA384", "SHA512", "SHA-256", "SHA-384", "SHA-512"] and
  msg = "Use of unapproved hash algorithm or API " + name + "."
select alg, msg
