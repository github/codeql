/**
 * @name Authenticated Encryption Algorithms
 * @description Finds all potential usage of authenticated encryption schemes using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/authenticated-encryption-algorithms
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from AuthenticatedEncryptionAlgorithm alg
select alg, "Use of algorithm " + alg.getAuthticatedEncryptionName()
