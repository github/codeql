/**
 * @name Symmetric Padding Schemes
 * @description Finds all potential usage of padding schemes used with symmeric algorithms.
 * @kind problem
 * @id cpp/quantum-readiness/cbom/symmetric-padding-schemes
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import cpp
import experimental.cryptography.Concepts

// TODO: currently not modeled for any API
from SymmetricPadding alg
select alg, "Use of algorithm " + alg.getPaddingName()
