/**
 * @name Weak symmetric ciphers
 * @description Finds uses of cryptographic symmetric cipher algorithms that are unapproved or otherwise weak.
 * @id java/quantum/examples/weak-ciphers
 * @kind problem
 * @problem.severity error
 * @tags external/cwe/cwe-327
 *       quantum
 *       experimental
 */

import WeakSymmetricCipher

from Crypto::KeyOperationAlgorithmNode alg, string msg
where isUnapprovedSymmetricCipher(alg, msg)
select alg, msg
