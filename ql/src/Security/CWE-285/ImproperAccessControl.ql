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

from LocalJob job, LabelControlCheck check, MutableRefCheckoutStep checkout, Event event
where
  job = checkout.getEnclosingJob() and
  job.isPrivileged() and
  job.getATriggerEvent() = event and
  event.getName() = "pull_request_target" and
  event.getAnActivityType() = "synchronize" and
  job.getAStep() = checkout and
  (
    checkout.getIf() = check
    or
    checkout.getEnclosingJob().getIf() = check
  )
select checkout, "The checked-out code can be changed after the authorization check o step $@.",
  check, check.toString()
