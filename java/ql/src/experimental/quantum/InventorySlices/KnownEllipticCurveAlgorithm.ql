/**
 * @name Detects known elliptic curve algorithms
 * @id java/crypto_inventory_slices/known_elliptic_curve_algorithm
 * @kind table
 */

import java
import experimental.quantum.Language

from Crypto::EllipticCurveNode a
select a, "Instance of elliptic curve algorithm " + a.getAlgorithmName()
