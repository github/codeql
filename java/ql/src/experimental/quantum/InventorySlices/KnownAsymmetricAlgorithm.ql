/**
 * @name Operations using known asymmetric cipher algorithms (slice)
 * @description Outputs operations where the algorithm used is a known asymmetric cipher algorithm.
 * @id java/quantum/slices/known-asymmetric-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::AsymmetricAlgorithmNode a
select a, a.getAlgorithmName()
