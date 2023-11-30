/**
 * @name Initialization Vector (IV) or nonces
 * @description Finds all potential sources for initialization vectors (IV) or nonce used in block ciphers while using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/iv-sources
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

// TODO: currently not modeled for any API
from BlockModeAlgorithm alg
select alg.getIVorNonce(), "Block mode IV/Nonce source"
