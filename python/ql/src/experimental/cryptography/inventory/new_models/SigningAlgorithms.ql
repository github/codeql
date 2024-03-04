/**
 * @name Signing Algorithms
 * @description Finds all potential usage of signing algorithms using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/signing-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from SigningAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
