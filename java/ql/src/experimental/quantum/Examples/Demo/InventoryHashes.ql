/**
 * @name Inventory of hash algorithms
 * @description Lists all detected hash algorithms with their digest length.
 * @id java/quantum/examples/demo/inventory-hashes
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::HashAlgorithmNode h, string detail
where
  if exists(h.getDigestLength())
  then
    detail =
      "Hash algorithm: " + h.getHashType().toString() + " (" + h.getDigestLength().toString() +
        "-bit digest)."
  else detail = "Hash algorithm: " + h.getHashType().toString() + "."
select h, detail
