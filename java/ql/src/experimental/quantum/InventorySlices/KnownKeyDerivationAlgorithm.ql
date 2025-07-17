/**
 * @name Known key derivation algorithms (slice)
 * @description Outputs known key derivation algorithms.
 * @id java/quantum/slices/known-key-derivation-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyDerivationAlgorithmNode alg
select alg, alg.getAlgorithmName()
