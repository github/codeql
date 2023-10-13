/**
 * @name Signing Algorithms
 * @description Finds all potential usage of signing algorithms using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/signing-algorithms
 * @problem.severity error
 * @precision high
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

// TODO: currently not modeled for any API
from SigningAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
