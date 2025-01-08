/**
 * @name Unversioned Immutable Action
 * @description Using an Immutable Action without a semantic version tag opts out of the protections of Immutable Action
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id actions/unversioned-immutable-action
 * @tags security
 *       actions
 *       internal
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.UseOfUnversionedImmutableAction

from UnversionedImmutableAction step
select step, "The workflow is using an eligible immutable action ($@) without semantic versioning",
  step, step.getCallee()
