/**
 * @name Inventory of elliptic curves
 * @description Lists all detected elliptic curve algorithms with their family and key size.
 * @id java/quantum/examples/demo/inventory-curves
 * @kind problem
 * @problem.severity recommendation
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

from Crypto::EllipticCurveNode c, string detail
where
  if c.properties("KeySize", _, _)
  then
    exists(string ks |
      c.properties("KeySize", ks, _) and
      detail =
        "Elliptic curve: " + c.getAlgorithmName() + " (" + c.getEllipticCurveType().toString() +
          " family, " + ks + "-bit)."
    )
  else
    detail =
      "Elliptic curve: " + c.getAlgorithmName() + " (" + c.getEllipticCurveType().toString() +
        " family)."
select c, detail
