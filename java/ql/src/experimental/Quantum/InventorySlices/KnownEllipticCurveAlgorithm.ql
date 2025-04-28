/**
 * @name Detects known elliptic curve algorithms
 * @id java/crypto_inventory_slices/known_elliptic_curvee_algorithm
 * @kind problem
 */

import java
import experimental.Quantum.Language

from Crypto::EllipticCurveNode a
select a, "Instance of elliptic curve algorithm " + a.getAlgorithmName()
