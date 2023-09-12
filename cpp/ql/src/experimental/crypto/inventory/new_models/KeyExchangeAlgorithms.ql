/**
 * @name Key Exchange Algorithms
 * @description Finds all potential usage of key exchange using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/key-exchange
 * @problem.severity error
 * @precision high
 * @tags security
 *       cbom
 *       cryptography
 */

import cpp
import experimental.crypto.Concepts

from KeyExchangeAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
