/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from
  Crypto::CipherOperationNode op, Crypto::CipherAlgorithmNode a,
  Crypto::ModeOfOperationAlgorithmNode m, Crypto::PaddingAlgorithmNode p,
  Crypto::NonceArtifactNode nonce
where
  a = op.getAKnownCipherAlgorithm() and
  m = a.getModeOfOperation() and
  p = a.getPaddingAlgorithm() and
  nonce = op.getANonce()
select op, op.getCipherOperationSubtype(), a, a.getRawAlgorithmName(), m, m.getRawAlgorithmName(),
  p, p.getRawAlgorithmName(), nonce
