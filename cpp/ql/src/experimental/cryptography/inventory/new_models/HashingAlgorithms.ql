/**
 * @name Hash Algorithms
 * @description Finds all potential usage of cryptographic hash algorithms using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/hash-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from HashAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
