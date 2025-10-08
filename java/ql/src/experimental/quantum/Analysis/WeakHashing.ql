/**
 * @name Weak hashes
 * @description Finds uses of cryptographic hashing algorithms that are unapproved or otherwise weak.
 * @id java/quantum/weak-hashes
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::HashAlgorithmNode alg, Crypto::HashType htype, string msg
where
  htype = alg.getHashType() and
  (
    htype != Crypto::SHA2() and
    msg = "Use of unapproved hash algorithm or API " + htype.toString() + "."
    or
    htype = Crypto::SHA2() and
    not exists(alg.getDigestLength()) and
    msg =
      "Use of approved hash algorithm or API type " + htype.toString() + " but unknown digest size."
    or
    htype = Crypto::SHA2() and
    alg.getDigestLength() < 256 and
    msg =
      "Use of approved hash algorithm or API type " + htype.toString() + " but weak digest size (" +
        alg.getDigestLength() + ")."
  )
select alg, msg
