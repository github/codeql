/**
 * @name Key Exchange Algorithms
 * @description Finds all potential usage of key exchange using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/key-exchange
 * @problem.severity error
 * @precision high
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from KeyExchangeAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
