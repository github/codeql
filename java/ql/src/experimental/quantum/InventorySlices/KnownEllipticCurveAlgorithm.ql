/**
 * @name Known elliptic curve algorithms (slice)
 * @description Outputs known elliptic curve algorithms.
 * @id java/quantum/slices/known-elliptic-curve-algorithm
 * @kind table
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::EllipticCurveNode a
select a, a.getAlgorithmName()
