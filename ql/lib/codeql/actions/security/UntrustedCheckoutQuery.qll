import actions
private import codeql.actions.DataFlow
private import codeql.actions.TaintTracking

/**
 * A taint-tracking configuration for PR HEAD references flowing
 * into actions/checkout's ref argument.
 */
private module ActionsMutableRefCheckoutConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // `ref` argument contains the PR id/number or head ref
    exists(Expression e |
      source.asExpr() = e and
      (
        containsHeadRef(e.getExpression()) or
        containsPullRequestNumber(e.getExpression())
      )
    )
    or
    // 3rd party actions returning the PR head ref
    exists(StepsExpression e, UsesStep step |
      source.asExpr() = e and
      e.getStepId() = step.getId() and
      (
        step.getCallee() = "eficode/resolve-pr-refs" and e.getFieldName() = "head_ref"
        or
        step.getCallee() = "xt0rted/pull-request-comment-branch" and e.getFieldName() = "head_ref"
        or
        step.getCallee() = "alessbell/pull-request-comment-branch" and e.getFieldName() = "head_ref"
        or
        step.getCallee() = "gotson/pull-request-comment-branch" and e.getFieldName() = "head_ref"
        or
        step.getCallee() = "potiuk/get-workflow-origin" and
        e.getFieldName() = ["sourceHeadBranch", "pullRequestNumber"]
        or
        step.getCallee() = "github/branch-deploy" and e.getFieldName() = ["ref", "fork_ref"]
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Uses uses |
      uses.getCallee() = "actions/checkout" and
      uses.getArgumentExpr("ref") = sink.asExpr()
    )
  }
}

module ActionsMutableRefCheckoutFlow = TaintTracking::Global<ActionsMutableRefCheckoutConfig>;

private module ActionsSHACheckoutConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // `ref` argument contains the PR head/merge commit sha
    exists(Expression e |
      source.asExpr() = e and
      containsHeadSHA(e.getExpression())
    )
    or
    // 3rd party actions returning the PR head sha
    exists(StepsExpression e, UsesStep step |
      source.asExpr() = e and
      e.getStepId() = step.getId() and
      (
        step.getCallee() = "eficode/resolve-pr-refs" and e.getFieldName() = "head_sha"
        or
        step.getCallee() = "xt0rted/pull-request-comment-branch" and e.getFieldName() = "head_sha"
        or
        step.getCallee() = "alessbell/pull-request-comment-branch" and e.getFieldName() = "head_sha"
        or
        step.getCallee() = "gotson/pull-request-comment-branch" and e.getFieldName() = "head_sha"
        or
        step.getCallee() = "potiuk/get-workflow-origin" and
        e.getFieldName() = ["sourceHeadSha", "mergeCommitSha"]
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Uses uses |
      uses.getCallee() = "actions/checkout" and
      uses.getArgumentExpr("ref") = sink.asExpr()
    )
  }
}

module ActionsSHACheckoutFlow = TaintTracking::Global<ActionsSHACheckoutConfig>;

bindingset[s]
predicate containsPullRequestNumber(string s) {
  exists(
    normalizeExpr(s)
        .regexpFind([
            "\\bgithub\\.event\\.number\\b", "\\bgithub\\.event\\.issue\\.number\\b",
            "\\bgithub\\.event\\.pull_request\\.id\\b",
            "\\bgithub\\.event\\.pull_request\\.number\\b",
            "\\bgithub\\.event\\.check_suite\\.pull_requests\\[\\d+\\]\\.id\\b",
            "\\bgithub\\.event\\.check_suite\\.pull_requests\\[\\d+\\]\\.number\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.pull_requests\\[\\d+\\]\\.id\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.pull_requests\\[\\d+\\]\\.number\\b",
            "\\bgithub\\.event\\.check_run\\.pull_requests\\[\\d+\\]\\.id\\b",
            "\\bgithub\\.event\\.check_run\\.pull_requests\\[\\d+\\]\\.number\\b",
            // heuristics
            "\\bpr_number\\b", "\\bpr_id\\b"
          ], _, _)
  )
}

bindingset[s]
predicate containsHeadSHA(string s) {
  exists(
    normalizeExpr(s)
        .regexpFind([
            "\\bgithub\\.event\\.pull_request\\.head\\.sha\\b",
            "\\bgithub\\.event\\.pull_request\\.merge_commit_sha\\b",
            "\\bgithub\\.event\\.workflow_run\\.head_commit\\.id\\b",
            "\\bgithub\\.event\\.workflow_run\\.head_sha\\b",
            "\\bgithub\\.event\\.check_suite\\.after\\b",
            "\\bgithub\\.event\\.check_suite\\.head_commit\\.id\\b",
            "\\bgithub\\.event\\.check_suite\\.head_sha\\b",
            "\\bgithub\\.event\\.check_suite\\.pull_requests\\[\\d+\\]\\.head\\.sha\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.after\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.head_commit\\.id\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.head_sha\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.pull_requests\\[\\d+\\]\\.head\\.sha\\b",
            "\\bgithub\\.event\\.check_run\\.head_sha\\b",
            "\\bgithub\\.event\\.check_run\\.pull_requests\\[\\d+\\]\\.head\\.sha\\b",
            "\\bgithub\\.event\\.merge_group\\.head_sha\\b",
            "\\bgithub\\.event\\.merge_group\\.head_commit\\.id\\b",
            // heuristics
            "\\bhead\\.sha\\b", "\\bhead_sha\\b", "\\bpr_head_sha\\b"
          ], _, _)
  )
}

bindingset[s]
predicate containsHeadRef(string s) {
  exists(
    normalizeExpr(s)
        .regexpFind([
            "\\bgithub\\.event\\.pull_request\\.head\\.ref\\b", "\\bgithub\\.head_ref\\b",
            "\\bgithub\\.event\\.workflow_run\\.head_branch\\b",
            "\\bgithub\\.event\\.check_suite\\.pull_requests\\[\\d+\\]\\.head\\.ref\\b",
            "\\bgithub\\.event\\.check_run\\.check_suite\\.pull_requests\\[\\d+\\]\\.head\\.ref\\b",
            "\\bgithub\\.event\\.check_run\\.pull_requests\\[\\d+\\]\\.head\\.ref\\b",
            "\\bgithub\\.event\\.merge_group\\.head_ref\\b",
            // heuristics
            "\\bhead\\.ref\\b", "\\bhead_ref\\b", "\\bpr_head_ref\\b",
            // env vars
            "GITHUB_HEAD_REF",
          ], _, _)
  )
}

/** Checkout of a Pull Request HEAD */
abstract class PRHeadCheckoutStep extends Step {
  abstract string getPath();
}

/** Checkout of a Pull Request HEAD ref */
abstract class MutableRefCheckoutStep extends PRHeadCheckoutStep { }

/** Checkout of a Pull Request HEAD ref */
abstract class SHACheckoutStep extends PRHeadCheckoutStep { }

/** Checkout of a Pull Request HEAD ref using actions/checkout action */
class ActionsMutableRefCheckout extends MutableRefCheckoutStep instanceof UsesStep {
  ActionsMutableRefCheckout() {
    this.getCallee() = "actions/checkout" and
    (
      exists(ActionsMutableRefCheckoutFlow::PathNode sink |
        ActionsMutableRefCheckoutFlow::flowPath(_, sink) and
        sink.getNode().asExpr() = this.getArgumentExpr("ref")
      )
      or
      // heuristic base on the step id and field name
      exists(StepsExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getStepId().matches("%" + ["head", "branch", "ref"] + "%") or
          e.getFieldName().matches("%" + ["head", "branch", "ref"] + "%")
        )
      )
      or
      exists(NeedsExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getNeededJobId().matches("%" + ["head", "branch", "ref"] + "%") or
          e.getFieldName().matches("%" + ["head", "branch", "ref"] + "%")
        )
      )
      or
      exists(JsonReferenceExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getAccessPath().matches("%." + ["head", "branch", "ref"] + "%") or
          e.getInnerExpression().matches("%." + ["head", "branch", "ref"] + "%")
        )
      )
    )
  }

  override string getPath() {
    if exists(this.(UsesStep).getArgument("path"))
    then result = this.(UsesStep).getArgument("path")
    else result = "GITHUB_WORKSPACE/"
  }
}

/** Checkout of a Pull Request HEAD ref using actions/checkout action */
class ActionsSHACheckout extends SHACheckoutStep instanceof UsesStep {
  ActionsSHACheckout() {
    this.getCallee() = "actions/checkout" and
    (
      exists(ActionsSHACheckoutFlow::PathNode sink |
        ActionsSHACheckoutFlow::flowPath(_, sink) and
        sink.getNode().asExpr() = this.getArgumentExpr("ref")
      )
      or
      // heuristic base on the step id and field name
      exists(StepsExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getStepId().matches("%" + ["head", "sha", "commit"] + "%") or
          e.getFieldName().matches("%" + ["head", "sha", "commit"] + "%")
        )
      )
      or
      exists(NeedsExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getNeededJobId().matches("%" + ["head", "sha", "commit"] + "%") or
          e.getFieldName().matches("%" + ["head", "sha", "commit"] + "%")
        )
      )
      or
      exists(JsonReferenceExpression e |
        this.getArgumentExpr("ref") = e and
        (
          e.getAccessPath().matches("%." + ["head", "sha", "commit"] + "%") or
          e.getInnerExpression().matches("%." + ["head", "sha", "commit"] + "%")
        )
      )
    )
  }

  override string getPath() {
    if exists(this.(UsesStep).getArgument("path"))
    then result = this.(UsesStep).getArgument("path")
    else result = "GITHUB_WORKSPACE/"
  }
}

/** Checkout of a Pull Request HEAD ref using git within a Run step */
class GitMutableRefCheckout extends MutableRefCheckoutStep instanceof Run {
  GitMutableRefCheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*git\\s+(fetch|pull).*") and
      (
        (containsHeadRef(line) or containsPullRequestNumber(line))
        or
        exists(string varname, string expr |
          expr = this.getInScopeEnvVarExpr(varname).getExpression() and
          (
            containsHeadRef(expr) or
            containsPullRequestNumber(expr)
          ) and
          exists(line.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using git within a Run step */
class GitSHACheckout extends SHACheckoutStep instanceof Run {
  GitSHACheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*git\\s+(fetch|pull).*") and
      (
        containsHeadSHA(line)
        or
        exists(string varname, string expr |
          expr = this.getInScopeEnvVarExpr(varname).getExpression() and
          containsHeadSHA(expr) and
          exists(line.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using gh within a Run step */
class GhMutableRefCheckout extends MutableRefCheckoutStep instanceof Run {
  GhMutableRefCheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*(gh|hub)\\s+pr\\s+checkout.*") and
      (
        (containsHeadRef(line) or containsPullRequestNumber(line))
        or
        exists(string varname |
          (
            containsHeadRef(this.getInScopeEnvVarExpr(varname).getExpression()) or
            containsPullRequestNumber(this.getInScopeEnvVarExpr(varname).getExpression())
          ) and
          exists(line.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using gh within a Run step */
class GhSHACheckout extends SHACheckoutStep instanceof Run {
  GhSHACheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*gh\\s+pr\\s+checkout.*") and
      (
        containsHeadSHA(line)
        or
        exists(string varname |
          containsHeadSHA(this.getInScopeEnvVarExpr(varname).getExpression()) and
          exists(line.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}
