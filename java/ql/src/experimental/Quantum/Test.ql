/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from Crypto::EncryptionAlgorithm a, Crypto::ModeOfOperationAlgorithm mode
where a.getModeOfOperation() = mode
select a, a.getAlgorithmName(), a.getRawAlgorithmName(), mode, mode.getAlgorithmName()
