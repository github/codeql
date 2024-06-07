/**
 * @name Checkout of untrusted code in trusted context
 * @description Workflows triggered on `pull_request_target` have read/write access to the base repository and access to secrets.
 *              By explicitly checking out and running the build script from a fork the untrusted code is running in an environment
 *              that is able to push to the base repository and to access secrets.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id js/actions/pull-request-target
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-094
 */

import javascript
import semmle.javascript.Actions

/**
 * An action step that doesn't contain `actor` check in `if:` or
 * the check requires manual analysis.
 */
class ProbableStep extends Actions::Step {
  // some simplistic checks to eleminate likely false positives:
  ProbableStep() {
    // no if at all
    not exists(this.getIf().getValue())
    or
    // needs manual analysis if there is OR
    this.getIf().getValue().matches("%||%")
    or
    // actor check means only the user is able to run it
    not exists(this.getIf().getValue().regexpFind("\\bgithub\\s*\\.\\s*actor\\s*==", _, _))
  }
}

/**
 * An action job that doesn't contain `actor` check in `if:` or
 * the check requires manual analysis.
 */
class ProbableJob extends Actions::Job {
  // some simplistic checks to eleminate likely false positives:
  ProbableJob() {
    // no if at all
    not exists(this.getIf().getValue())
    or
    // needs manual analysis if there is OR
    this.getIf().getValue().matches("%||%")
    or
    // actor check means only the user is able to run it
    not exists(this.getIf().getValue().regexpFind("\\bgithub\\s*\\.\\s*actor\\s*==", _, _))
  }
}

/**
 * The `on: pull_request_target`.
 */
class ProbablePullRequestTarget extends Actions::On, YamlMappingLikeNode {
  ProbablePullRequestTarget() {
    // The `on:` is triggered on `pull_request_target`
    exists(this.getNode("pull_request_target"))
  }
}

from
  Actions::Ref ref, Actions::Uses uses, Actions::Step step, Actions::Job job,
  ProbablePullRequestTarget pullRequestTarget
where
  pullRequestTarget.getWorkflow() = job.getWorkflow() and
  uses.getStep() = step and
  ref.getWith().getStep() = step and
  step.getJob() = job and
  uses.getGitHubRepository() = "actions/checkout" and
  ref.getValue()
      .matches([
          "%github.event.pull_request.head.ref%", "%github.event.pull_request.head.sha%",
          "%github.event.pull_request.number%", "%github.event.number%", "%github.head_ref%"
        ]) and
  step instanceof ProbableStep and
  job instanceof ProbableJob
select step, "Potential unsafe checkout of untrusted pull request on 'pull_request_target'."
