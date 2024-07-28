/**
 * @name Elliptic Curve Algorithms
 * @description Finds all potential usage of elliptic curve algorithms using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/elliptic-curve-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from EllipticCurveAlgorithm alg
select alg, "Use of algorithm " + alg.getCurveName()
