/**
 * @name Unknown Initialization Vector (IV) or nonces
 * @description Finds all potentially unknown sources for initialization vectors (IV) or nonce used in block ciphers while using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/unkown-iv-sources
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from BlockMode alg
where not alg.hasIVorNonce()
select alg, "Block mode with unknown IV or Nonce configuration"
