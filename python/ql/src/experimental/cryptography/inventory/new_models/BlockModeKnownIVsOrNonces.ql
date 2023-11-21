/**
 * @name Initialization Vector (IV) or nonces
 * @description Finds all potential sources for initialization vectors (IV) or nonce used in block ciphers while using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/iv-sources
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from BlockMode alg
select alg.getIVorNonce().asExpr(), "Block mode IV/Nonce source"
