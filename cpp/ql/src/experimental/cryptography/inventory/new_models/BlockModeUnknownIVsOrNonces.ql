/**
 * @name Unknown Initialization Vector (IV) or nonces
 * @description Finds all potentially unknown sources for initialization vectors (IV) or nonce used in block ciphers while using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/unkown-iv-sources
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

// TODO: currently not modeled for any API
from BlockModeAlgorithm alg
where not alg.hasIVorNonce()
select alg, "Block mode with unknown IV or Nonce configuration"
