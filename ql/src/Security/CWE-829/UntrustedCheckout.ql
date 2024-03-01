/**
 * @name Checkout of untrusted code in trusted context
 * @description Workflows triggered on `pull_request_target` have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @security-severity 9.3
 * @id actions/untrusted-checkout
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions

/**
 * An If node that contains an `actor` check
 */
class ActorCheck extends If {
  ActorCheck() { this.getCondition().regexpMatch(".*github\\.(triggering_)?actor.*") }
}

/**
 * An If node that contains a `label` check
 */
class LabelCheck extends If {
  LabelCheck() {
    this.getCondition().regexpMatch(".*github\\.event\\.pull_request\\.labels.*") or
    this.getCondition().regexpMatch(".*github\\.event\\.label\\.name.*")
  }
}

from Workflow w, Job job, UsesStep checkoutStep
where
  w.hasTriggerEvent("pull_request_target") and
  w.getAJob() = job and
  job.getAStep() = checkoutStep and
  checkoutStep.getCallee() = "actions/checkout" and
  checkoutStep
      .getArgument("ref")
      .(Expression)
      .getExpression()
      .matches([
          "%github.event.pull_request.head.ref%", "%github.event.pull_request.head.sha%",
          "%github.event.pull_request.number%", "%github.event.number%", "%github.head_ref%"
        ]) and
  not exists(ActorCheck check | job.getIf() = check or checkoutStep.getIf() = check) and
  not exists(LabelCheck check | job.getIf() = check or checkoutStep.getIf() = check)
select checkoutStep, "Potential unsafe checkout of untrusted pull request on 'pull_request_target'."
