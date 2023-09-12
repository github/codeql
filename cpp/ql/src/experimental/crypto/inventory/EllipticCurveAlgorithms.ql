/**
 * @name Elliptic Curve Algorithms
 * @description Finds all potential usage of elliptic curve algorithms using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/elliptic-curve-algorithms
 * @problem.severity error
 * @precision high
 * @tags security
 *       cbom
 *       cryptography
 */

import cpp
import experimental.crypto.Concepts

from EllipticCurveAlgorithm alg
select alg, "Use of algorithm " + alg.getCurveName()
