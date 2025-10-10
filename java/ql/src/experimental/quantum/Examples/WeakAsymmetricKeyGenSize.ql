/**
 * @name Weak Asymmetric Key Size
 * @id java/quantum/weak-asymmetric-key-gen-size
 * @description An asymmetric key of known size is less than 2048 bits for any non-elliptic curve key operation.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

from Crypto::KeyArtifactNode key, int keySize, Crypto::AlgorithmNode alg
where
  key.getCreatingOperation().getAKeySizeSource().asElement().(Literal).getValue().toInt() = keySize and
  alg = key.getAKnownAlgorithm() and // NOTE: if algorithm is not known (doesn't bind) we need a separate query
  not alg instanceof Crypto::EllipticCurveNode and // Elliptic curve sizes are handled separately and are more tied directly to the algorithm
  keySize < 2048
select key, "Use of weak asymmetric key size (" + keySize.toString() + " bits) for algorithm $@",
  alg, alg.getAlgorithmName()
