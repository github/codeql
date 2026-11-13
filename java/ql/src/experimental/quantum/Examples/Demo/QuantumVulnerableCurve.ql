/**
 * @name Quantum-vulnerable elliptic curve
 * @description Detects use of elliptic curves that are vulnerable to quantum computing attacks.
 * @id java/quantum/examples/demo/quantum-vulnerable-curve
 * @kind problem
 * @problem.severity warning
 * @tags quantum
 *       experimental
 */

import QuantumCryptoClassification

from Crypto::EllipticCurveNode curve, string msg
where
  isQuantumVulnerableCurveType(curve.getEllipticCurveType()) and
  msg =
    "Quantum-vulnerable elliptic curve: " + curve.getAlgorithmName() + " (" +
      curve.getEllipticCurveType().toString() + " family)."
select curve, msg
