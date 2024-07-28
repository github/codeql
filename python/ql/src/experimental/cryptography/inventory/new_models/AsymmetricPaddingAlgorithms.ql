/**
 * @name Asymmetric Padding Schemes
 * @description Finds all potential usage of padding schemes used with asymmeric algorithms.
 * @kind problem
 * @id py/quantum-readiness/cbom/asymmetric-padding-schemes
 * @problem.severity error
 * @tags cbom
 *       cryptography
 */

import python
import experimental.cryptography.Concepts

from AsymmetricPadding alg
select alg, "Use of algorithm " + alg.getPaddingName()
