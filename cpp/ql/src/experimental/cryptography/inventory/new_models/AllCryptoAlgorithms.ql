/**
 * @name All Cryptographic Algorithms
 * @description Finds all potential usage of cryptographic algorithms usage using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/all-cryptographic-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from CryptographicAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
