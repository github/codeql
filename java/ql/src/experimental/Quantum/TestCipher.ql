/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from
  Crypto::CipherOperation op, Crypto::CipherAlgorithm a, Crypto::ModeOfOperationAlgorithm m,
  Crypto::PaddingAlgorithm p, Crypto::Nonce nonce
where
  a = op.getAlgorithm() and
  m = a.getModeOfOperation() and
  p = a.getPadding() and
  nonce = op.getNonce()
select op, op.getCipherOperationMode(), a, a.getRawAlgorithmName(), m, m.getRawAlgorithmName(), p,
  p.getRawAlgorithmName(), nonce
