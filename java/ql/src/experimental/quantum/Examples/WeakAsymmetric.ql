/**
 * @name Weak Asymmetric Key Size
 * @id java/quantum/weak-asymmetric-key-size
 * @description An asymmetric cipher with a short key size is in use
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyOperationAlgorithmNode op, int keySize, string algName
where
  keySize = op.getKeySizeFixed() and
  keySize < 2048 and
  algName = op.getAlgorithmName() and
  // Can't be an elliptic curve
  op.getAlgorithmType() != Crypto::KeyOpAlg::AlgorithmType::EllipticCurveType()
select "Use of weak asymmetric key size (" + keySize.toString() + " bits) for algorithm " + algName
