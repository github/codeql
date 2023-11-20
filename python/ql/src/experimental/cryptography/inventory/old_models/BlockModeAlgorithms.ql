/**
 * @name Block cipher mode of operation
 * @description Finds all potential block cipher modes of operations using the supported libraries.
 * @kind problem
 * @id py/quantum-readiness/cbom/classic-model/block-cipher-mode
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import semmle.python.Concepts

from Cryptography::CryptographicOperation operation, string algName
where algName = operation.getBlockMode()
select operation, "Use of algorithm " + algName
