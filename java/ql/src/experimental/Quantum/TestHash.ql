/**
 * @name TestHashOperations
 */

import experimental.Quantum.Language

from Crypto::HashOperationNode op, Crypto::HashAlgorithmNode alg
where alg = op.getAKnownHashAlgorithm()
select op, op.getDigest(), alg, alg.getRawAlgorithmName()
