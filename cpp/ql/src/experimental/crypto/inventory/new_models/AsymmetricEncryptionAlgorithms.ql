/**
 * @name Asymmetric Encryption Algorithms
 * @description Finds all potential usage of asymmeric keys for encryption or key exchange using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/all-asymmetric-encryption-algorithms
 * @problem.severity error
 * @precision high
 * @tags security
 *       cbom
 *       cryptography
 */

import cpp
import experimental.crypto.Concepts

from AsymmetricEncryptionAlgorithm alg
select alg, "Use of algorithm " + alg.getEncryptionName()
