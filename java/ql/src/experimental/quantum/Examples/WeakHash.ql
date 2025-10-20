/**
 * @name Weak hashes
 * @description Finds uses of cryptographic hashing algorithms that are unapproved or otherwise weak.
 * @id java/quantum/examples/weak-hash
 * @kind problem
 * @problem.severity error
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import WeakHash

from Crypto::HashAlgorithmNode alg, Crypto::HashType htype, string msg
where isUnapprovedHash(alg, htype, msg)
select alg, msg
