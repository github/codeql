/**
 * @name "Hash operation slice table demo query"
 */

import experimental.quantum.Language

from Crypto::HashOperationNode op, Crypto::HashAlgorithmNode alg
where alg = op.getAKnownAlgorithm()
select op, op.getDigest(), alg, alg.getRawAlgorithmName()
