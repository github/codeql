/**
 * @name "Key operation slice table demo query"
 */

import experimental.Quantum.Language

from
  Crypto::KeyOperationNode op, Crypto::KeyOperationAlgorithmNode a,
  Crypto::ModeOfOperationAlgorithmNode m, Crypto::PaddingAlgorithmNode p,
  Crypto::NonceArtifactNode nonce, Crypto::KeyArtifactNode k
where
  a = op.getAKnownAlgorithm() and
  m = a.getModeOfOperation() and
  p = a.getPaddingAlgorithm() and
  nonce = op.getANonce() and
  k = op.getAKey()
select op, op.getKeyOperationSubtype(), a, a.getRawAlgorithmName(), m, m.getRawAlgorithmName(), p,
  p.getRawAlgorithmName(), nonce, k
