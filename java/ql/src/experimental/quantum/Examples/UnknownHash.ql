/**
 * @name Unknown hashes
 * @description Finds uses of cryptographic hashing algorithms of unknown type.
 * @id java/quantum/examples/unknown-hash
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::HashAlgorithmNode alg
where
  not exists(alg.getHashType())
  or
  alg.getHashType() = Crypto::OtherHashType()
select alg, "Use of unknown hash algorithm."
