/**
 * @name Weak KDF algorithm.
 * @description Approved KDF algorithms must one of the following
 *  ["PBKDF2" , "PBKDF2HMAC", "KBKDF", "KBKDFHMAC", "CONCATKDF", "CONCATKDFHASH"]
 * @assumption The value being used to derive a key (either a key or a password) is correct for the algorithm (i.e., a key is used for KBKDF and a password for PBKDF).
 * @kind problem
 * @id py/weak-kdf-algorithm
 * @problem.severity error
 * @precision high
 */

import python
import experimental.cryptography.Concepts

from KeyDerivationAlgorithm op
where
  not op.getKDFName() =
    [
      "PBKDF2", "PBKDF2HMAC", "KBKDF", "KBKDFHMAC", "KBKDFCMAC", "CONCATKDF", "CONCATKDFHASH",
      "CONCATKDFHMAC"
    ]
select op, "Use of unapproved, weak, or unknown key derivation algorithm or API."
