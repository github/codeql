/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from Crypto::EncryptionAlgorithm a, Crypto::ModeOfOperationAlgorithm m, Crypto::PaddingAlgorithm p
where m = a.getModeOfOperation() and p = a.getPadding()
select a, a.getRawAlgorithmName(), m, m.getRawAlgorithmName(), p, p.getRawAlgorithmName()
