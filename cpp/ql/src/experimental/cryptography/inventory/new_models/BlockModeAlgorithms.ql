/**
 * @name Block cipher mode of operation
 * @description Finds all potential block cipher modes of operations using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/block-cipher-mode
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from BlockModeAlgorithm alg
select alg, "Use of algorithm " + alg.getBlockModeName()
