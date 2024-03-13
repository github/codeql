/**
 * @name Elliptic Curve Key length
 * @description Finds all potential key lengths for elliptic curve algorithms usage.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/elliptic-curve-key-length
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from EllipticCurveAlgorithm alg, string size
where
  if not exists(alg.getCurveBitSize())
  then size = "UNKNOWN SIZE"
  else size = alg.getCurveBitSize().toString()
select alg, "Use of algorithm " + alg.getCurveName() + " with key size (in bits) " + size
