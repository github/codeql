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

/** An If node that contains an actor, user or label check */
class ControlCheck extends If {
  ControlCheck() {
    Utils::normalizeExpr(this.getCondition())
        .regexpMatch([
            ".*github\\.actor.*", ".*github\\.triggering_actor.*",
            ".*github\\.event\\.pull_request\\.user\\.login.*",
            ".*github\\.event\\.pull_request\\.labels.*", ".*github\\.event\\.label\\.name.*"
          ])
  }
}

bindingset[s]
predicate containsHeadRef(string s) {
  Utils::normalizeExpr(s)
      .matches("%" +
          [
            "github.event.number", // The pull request number.
            "github.event.pull_request.head.ref", // The ref name of head.
            "github.event.pull_request.head.sha", //  The commit SHA of head.
            "github.event.pull_request.id", // The pull request ID.
            "github.event.pull_request.number", // The pull request number.
            "github.event.pull_request.merge_commit_sha", // The SHA of the merge commit.
            "github.head_ref", // The head_ref or source branch of the pull request in a workflow run.
            "github.event.workflow_run.head_branch", // The branch of the head commit.
            "github.event.workflow_run.head_commit.id", // The SHA of the head commit.
            "github.event.workflow_run.head_sha", // The SHA of the head commit.
            "env.GITHUB_HEAD_REF",
          ] + "%")
}

/** Checkout of a Pull Request HEAD ref */
abstract class PRHeadCheckoutStep extends Step { }

/** Checkout of a Pull Request HEAD ref using actions/checkout action */
class ActionsCheckout extends PRHeadCheckoutStep instanceof UsesStep {
  ActionsCheckout() {
    this.getCallee() = "actions/checkout" and
    containsHeadRef(this.getArgumentExpr("ref").getExpression())
  }
}

/** Checkout of a Pull Request HEAD ref using git within a Run step */
class GitCheckout extends PRHeadCheckoutStep instanceof Run {
  GitCheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*git\\s+fetch.*") and
      (
        containsHeadRef(line)
        or
        exists(string varname |
          containsHeadRef(this.getInScopeEnvVarExpr(varname).getExpression()) and
          line.matches("%" + varname + "%")
        )
      )
    )
  }
}

from Workflow w, PRHeadCheckoutStep checkout
where
  w.hasTriggerEvent(["pull_request_target", "issue_comment", "workflow_run"]) and
  w.getAJob().(LocalJob).getAStep() = checkout and
  not exists(ControlCheck check |
    checkout.getIf() = check or checkout.getEnclosingJob().getIf() = check
  )
select checkout, "Potential unsafe checkout of untrusted pull request on privileged workflow."
