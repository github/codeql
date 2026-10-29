/**
 * @name Weak hashes
 * @description Finds uses of cryptography algorithms that are unapproved or otherwise weak.
 * @id py/weak-hashes
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import python
import experimental.cryptography.Concepts

from HashAlgorithm op, string name, string msg
where
  name = op.getHashName() and
  not name = ["SHA256", "SHA384", "SHA512"] and
  if name = unknownAlgorithm()
  then msg = "Use of unrecognized hash algorithm."
  else msg = "Use of unapproved hash algorithm or API " + name + "."
select op, msg
