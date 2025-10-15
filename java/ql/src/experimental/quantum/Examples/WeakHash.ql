/**
 * @name Weak hashes
 * @description Finds uses of cryptographic hashing algorithms that are unapproved or otherwise weak.
 * @id java/quantum/weak-hash
 * @kind problem
 * @problem.severity error
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
    (htype != Crypto::SHA2() and htype != Crypto::SHA3()) and
    msg = "Use of unapproved hash algorithm or API: " + htype.toString() + "."
    or
    (htype = Crypto::SHA2() or htype = Crypto::SHA3()) and
    not exists(alg.getDigestLength()) and
    msg =
      "Use of approved hash algorithm or API type " + htype.toString() + " but unknown digest size."
    or
    exists(int digestLength |
      digestLength = alg.getDigestLength() and
      (htype = Crypto::SHA2() or htype = Crypto::SHA3()) and
      digestLength < 256 and
      msg =
        "Use of approved hash algorithm or API type " + htype.toString() + " but weak digest size ("
          + digestLength + ")."
    )
  )
select alg, msg
