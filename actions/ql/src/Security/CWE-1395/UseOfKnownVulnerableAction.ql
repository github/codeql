/**
 * @name Use of a known vulnerable action.
 * @description The workflow is using an action with known vulnerabilities.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id actions/vulnerable-action
 * @tags actions
 *       security
 *       external/cwe/cwe-1395
 */

import actions
import codeql.actions.security.UseOfKnownVulnerableActionQuery

from KnownVulnerableAction step
select step,
  "The workflow is using a known vulnerable version ($@) of the $@ action. Update it to $@", step,
  step.getVersion(), step, step.getCallee(), step, step.getFixedVersion()
