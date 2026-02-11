/**
 * @name Operations using known asymmetric algorithms (slice)
 * @description Outputs operations where the algorithm used is a known asymmetric algorithm.
 * @id java/quantum/slices/known-asymmetric-operation-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::OperationNode op, Crypto::AsymmetricAlgorithmNode a
where a = op.getAKnownAlgorithm()
select op, a.asAlgorithmNode().getAlgorithmName()
