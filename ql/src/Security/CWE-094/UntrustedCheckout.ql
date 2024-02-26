/**
 * @name Checkout of untrusted code in trusted context
 * @description Workflows triggered on `pull_request_target` have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id actions/untrusted-checkout
 * @tags actions
 *       security
 *       external/cwe/cwe-094
 */

import actions

/**
 * An If node that contains an `actor` check
 */
class ActorCheckStmt extends IfStmt {
  ActorCheckStmt() { this.getCondition().regexpMatch(".*github\\.(triggering_)?actor.*") }
}

/**
 * An If node that contains a `label` check
 */
class LabelCheckStmt extends IfStmt {
  LabelCheckStmt() {
    this.getCondition().regexpMatch(".*github\\.event\\.pull_request\\.labels.*") or
    this.getCondition().regexpMatch(".*github\\.event\\.label\\.name.*")
  }
}

from WorkflowStmt w, JobStmt job, StepUsesExpr checkoutStep
where
  w.hasTriggerEvent("pull_request_target") and
  w.getAJobStmt() = job and
  job.getAStepStmt() = checkoutStep and
  checkoutStep.getCallee() = "actions/checkout" and
  checkoutStep
      .getArgumentExpr("ref")
      .(ExprAccessExpr)
      .getExpression()
      .matches([
          "%github.event.pull_request.head.ref%", "%github.event.pull_request.head.sha%",
          "%github.event.pull_request.number%", "%github.event.number%", "%github.head_ref%"
        ]) and
  not exists(ActorCheckStmt check | job.getIfStmt() = check or checkoutStep.getIfStmt() = check) and
  not exists(LabelCheckStmt check | job.getIfStmt() = check or checkoutStep.getIfStmt() = check)
select checkoutStep, "Potential unsafe checkout of untrusted pull request on 'pull_request_target'."
