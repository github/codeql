/**
 * @name All Asymmetric Algorithms
 * @description Finds all potential usage of asymmeric keys (RSA & ECC) using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/all-asymmetric-algorithms
 * @severity recommendation
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from AsymmetricAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
