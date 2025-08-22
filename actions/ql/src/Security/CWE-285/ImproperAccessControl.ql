/**
 * @name Improper Access Control
 * @description The access control mechanism is not properly implemented, allowing untrusted code to be executed in a privileged context.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @security-severity 9.3
 * @id actions/improper-access-control
 * @tags actions
 *       security
 *       external/cwe/cwe-285
 */

import codeql.actions.security.UntrustedCheckoutQuery
import codeql.actions.security.ControlChecks

from LocalJob job, LabelCheck check, MutableRefCheckoutStep checkout, Event event
where
  job.isPrivileged() and
  job.getAStep() = checkout and
  check.dominates(checkout) and
  (
    job.getATriggerEvent() = event and
    event.getName() = "pull_request_target" and
    event.getAnActivityType() = "synchronize"
    or
    not exists(job.getATriggerEvent())
  )
select checkout, "The checked-out code can be modified after the authorization check $@.", check,
  check.toString()
