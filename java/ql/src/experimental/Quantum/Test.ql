/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from Crypto::SymmetricAlgorithm a, Crypto::ModeOfOperation mode
where a.getModeOfOperation() = mode
select a, a.getAlgorithmName(), a.getRawAlgorithmName(), mode, mode.getAlgorithmName()
