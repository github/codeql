/**
 * @name All Cryptographic Algorithms
 * @description Finds all potential usage of cryptographic algorithms usage using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/all-cryptographic-algorithms
 * @problem.severity error
 * @precision high
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from CryptographicAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
