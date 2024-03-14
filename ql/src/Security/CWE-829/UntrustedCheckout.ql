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
    exists(
      Utils::normalizeExpr(this.getCondition())
          .regexpFind([
              "\\bgithub\\.actor\\b", // actor
              "\\bgithub\\.triggering_actor\\b", // actor
              "\\bgithub\\.event\\.pull_request\\.user\\.login\\b", //user
              "\\bgithub\\.event\\.pull_request\\.labels\\b", // label
              "\\bgithub\\.event\\.label\\.name\\b" // label
            ], _, _)
    )
  }
}

bindingset[s]
predicate containsHeadRef(string s) {
  exists(
    Utils::normalizeExpr(s)
        .regexpFind([
            "\\bgithub\\.event\\.number\\b", // The pull request number.
            "\\bgithub\\.event\\.issue\\.number\\b", // The pull request number on issue_comment.
            "\\bgithub\\.event\\.pull_request\\.head\\.ref\\b", // The ref name of head.
            "\\bgithub\\.event\\.pull_request\\.head\\.sha\\b", //  The commit SHA of head.
            "\\bgithub\\.event\\.pull_request\\.id\\b", // The pull request ID.
            "\\bgithub\\.event\\.pull_request\\.number\\b", // The pull request number.
            "\\bgithub\\.event\\.pull_request\\.merge_commit_sha\\b", // The SHA of the merge commit.
            "\\bgithub\\.head_ref\\b", // The head_ref or source branch of the pull request in a workflow run.
            "\\bgithub\\.event\\.workflow_run\\.head_branch\\b", // The branch of the head commit.
            "\\bgithub\\.event\\.workflow_run\\.head_commit\\.id\\b", // The SHA of the head commit.
            "\\bgithub\\.event\\.workflow_run\\.head_sha\\b", // The SHA of the head commit.
            "\\benv\\.GITHUB_HEAD_REF\\b",
          ], _, _)
  )
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
          exists(line.regexpFind(varname, _, _))
        )
      )
    )
  }
}

from Workflow w, PRHeadCheckoutStep checkout
where
  w.hasTriggerEvent(["pull_request_target", "issue_comment", "pull_request_review_comment", "pull_request_review", "workflow_run", "check_run", "check_suite", "workflow_call"]) and
  w.getAJob().(LocalJob).getAStep() = checkout and
  not exists(ControlCheck check |
    checkout.getIf() = check or checkout.getEnclosingJob().getIf() = check
  )
select checkout, "Potential unsafe checkout of untrusted pull request on privileged workflow."
