/**
 * @name Known asymmetric cipher algorithms (slice)
 * @description Outputs known asymmetric cipher algorithms.
 * @id java/quantum/slices/known-asymmetric-cipher-algorithm
 * @kind problem
 * @severity recommendation
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language
/* import codeql.quantum.experimental.Model */

from Crypto::KeyOperationAlgorithmNode a
where a.getAlgorithmType() instanceof Crypto::KeyOpAlg::AsymmetricCipherAlgorithmType
select a, a.getAlgorithmName()
