/**
 * @name Elliptic Curve Algorithms
 * @description Finds all potential usage of elliptic curve algorithms using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/elliptic-curve-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from EllipticCurveAlgorithm alg
select alg,
  "Use of algorithm " + alg.getCurveName() + " with key size (in bits) " +
    alg.getCurveBitSize().toString()
