/**
 * @name All Asymmetric Algorithms
 * @description Finds all potential usage of asymmeric keys (RSA & ECC) using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/all-asymmetric-algorithms
 * @problem.severity error
 * @precision high
 * @tags security
 *       cbom
 *       cryptography
 */

import cpp
import experimental.crypto.Concepts

from AsymmetricAlgorithm alg
select alg, "Use of algorithm " + alg.getName()
