/**
 * @name Weak symmetric encryption algorithm
 * @description Finds uses of symmetric cryptography algorithms that are weak, obsolete, or otherwise unaccepted.
 *
 *              The key lengths allowed are 128, 192, and 256 bits. These are all the key lengths supported by AES, so any
 *              application of AES is considered acceptable.
 * @id py/weak-symmetric-encryption
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import python
import experimental.cryptography.Concepts

from SymmetricEncryptionAlgorithm op, string name, string msg
where
  name = op.getEncryptionName() and
  not name = ["AES", "AES128", "AES192", "AES256"] and
  if name = unknownAlgorithm()
  then msg = "Use of unrecognized symmetric encryption algorithm."
  else msg = "Use of unapproved symmetric encryption algorithm or API " + name + "."
select op, msg
