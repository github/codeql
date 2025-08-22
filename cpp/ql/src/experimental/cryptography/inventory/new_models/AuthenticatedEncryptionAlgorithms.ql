/**
 * @name Authenticated Encryption Algorithms
 * @description Finds all potential usage of authenticated encryption schemes using the supported libraries.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/authenticated-encryption-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

from AuthenticatedEncryptionAlgorithm alg
select alg, "Use of algorithm " + alg.getAuthticatedEncryptionName()
