/**
 * @name Symmetric Padding Schemes
 * @description Finds all potential usage of padding schemes used with symmeric algorithms.
 * @kind problem
 * @id py/quantum-readiness/cbom/symmetric-padding-schemes
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from SymmetricPadding alg
select alg, "Use of algorithm " + alg.getPaddingName()
