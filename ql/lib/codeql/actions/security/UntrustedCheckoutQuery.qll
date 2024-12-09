import actions
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.FlowSources
private import codeql.actions.TaintTracking

string checkoutTriggers() {
  result = ["pull_request_target", "workflow_run", "workflow_call", "issue_comment"]
}

/**
 * A taint-tracking configuration for PR HEAD references flowing
 * into actions/checkout's ref argument.
 */
private module ActionsMutableRefCheckoutConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    (
      // remote flow sources
      source instanceof GitHubCtxSource
      or
      source instanceof GitHubEventCtxSource
      or
      source instanceof GitHubEventJsonSource
      or
      source instanceof MaDSource
      or
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
          step.getCallee() = "alessbell/pull-request-comment-branch" and
          e.getFieldName() = "head_ref"
          or
          step.getCallee() = "gotson/pull-request-comment-branch" and e.getFieldName() = "head_ref"
          or
          step.getCallee() = "potiuk/get-workflow-origin" and
          e.getFieldName() = ["sourceHeadBranch", "pullRequestNumber"]
          or
          step.getCallee() = "github/branch-deploy" and e.getFieldName() = ["ref", "fork_ref"]
        )
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Uses uses |
      uses.getCallee() = "actions/checkout" and
      uses.getArgumentExpr(["ref", "repository"]) = sink.asExpr()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScript() and
      exists(run.getScript().getAFileReadCommand())
    )
  }
}

module ActionsMutableRefCheckoutFlow = TaintTracking::Global<ActionsMutableRefCheckoutConfig>;

private module ActionsSHACheckoutConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().getATriggerEvent().getName() =
      ["pull_request_target", "workflow_run", "workflow_call", "issue_comment"] and
    (
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
          step.getCallee() = "alessbell/pull-request-comment-branch" and
          e.getFieldName() = "head_sha"
          or
          step.getCallee() = "gotson/pull-request-comment-branch" and e.getFieldName() = "head_sha"
          or
          step.getCallee() = "potiuk/get-workflow-origin" and
          e.getFieldName() = ["sourceHeadSha", "mergeCommitSha"]
        )
      )
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Uses uses |
      uses.getCallee() = "actions/checkout" and
      uses.getArgumentExpr(["ref", "repository"]) = sink.asExpr()
    )
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScript() and
      exists(run.getScript().getAFileReadCommand())
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
            "\\bhead\\.sha\\b", "\\bhead_sha\\b", "\\bmerge_sha\\b", "\\bpr_head_sha\\b"
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
            "\\bhead\\.ref\\b", "\\bhead_ref\\b", "\\bmerge_ref\\b", "\\bpr_head_ref\\b",
            // env vars
            "GITHUB_HEAD_REF",
          ], _, _)
  )
}

class SimplePRHeadCheckoutStep extends Step {
  SimplePRHeadCheckoutStep() {
    // This should be:
    // artifact instanceof PRHeadCheckoutStep
    // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
    // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
    // instead of using ActionsMutableRefCheckout and ActionsSHACheckout
    exists(Uses uses |
      this = uses and
      uses.getCallee() = "actions/checkout" and
      exists(uses.getArgument("ref")) and
      not uses.getArgument("ref").matches("%base%") and
      uses.getATriggerEvent().getName() = checkoutTriggers()
    )
    or
    this instanceof GitMutableRefCheckout
    or
    this instanceof GitSHACheckout
    or
    this instanceof GhMutableRefCheckout
    or
    this instanceof GhSHACheckout
  }
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
      exists(
        ActionsMutableRefCheckoutFlow::PathNode source, ActionsMutableRefCheckoutFlow::PathNode sink
      |
        ActionsMutableRefCheckoutFlow::flowPath(source, sink) and
        this.getArgumentExpr(["ref", "repository"]) = sink.getNode().asExpr()
      )
      or
      // heuristic base on the step id and field name
      exists(string value, Expression expr |
        value.regexpMatch(".*(head|branch|ref).*") and expr = this.getArgumentExpr("ref")
      |
        expr.(StepsExpression).getStepId() = value
        or
        expr.(SimpleReferenceExpression).getFieldName() = value and
        not expr instanceof GitHubExpression
        or
        expr.(NeedsExpression).getNeededJobId() = value
        or
        expr.(JsonReferenceExpression).getAccessPath() = value
        or
        expr.(JsonReferenceExpression).getInnerExpression() = value
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
      exists(ActionsSHACheckoutFlow::PathNode source, ActionsSHACheckoutFlow::PathNode sink |
        ActionsSHACheckoutFlow::flowPath(source, sink) and
        this.getArgumentExpr(["ref", "repository"]) = sink.getNode().asExpr()
      )
      or
      // heuristic base on the step id and field name
      exists(string value, Expression expr |
        value.regexpMatch(".*(head|sha|commit).*") and expr = this.getArgumentExpr("ref")
      |
        expr.(StepsExpression).getStepId() = value
        or
        expr.(SimpleReferenceExpression).getFieldName() = value and
        not expr instanceof GitHubExpression
        or
        expr.(NeedsExpression).getNeededJobId() = value
        or
        expr.(JsonReferenceExpression).getAccessPath() = value
        or
        expr.(JsonReferenceExpression).getInnerExpression() = value
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
    exists(string cmd | this.getScript().getACommand() = cmd |
      cmd.regexpMatch("git\\s+(fetch|pull).*") and
      (
        (containsHeadRef(cmd) or containsPullRequestNumber(cmd))
        or
        exists(string varname, string expr |
          expr = this.getInScopeEnvVarExpr(varname).getExpression() and
          (
            containsHeadRef(expr) or
            containsPullRequestNumber(expr)
          ) and
          exists(cmd.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using git within a Run step */
class GitSHACheckout extends SHACheckoutStep instanceof Run {
  GitSHACheckout() {
    exists(string cmd | this.getScript().getACommand() = cmd |
      cmd.regexpMatch("git\\s+(fetch|pull).*") and
      (
        containsHeadSHA(cmd)
        or
        exists(string varname, string expr |
          expr = this.getInScopeEnvVarExpr(varname).getExpression() and
          containsHeadSHA(expr) and
          exists(cmd.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using gh within a Run step */
class GhMutableRefCheckout extends MutableRefCheckoutStep instanceof Run {
  GhMutableRefCheckout() {
    exists(string cmd | this.getScript().getACommand() = cmd |
      cmd.regexpMatch(".*(gh|hub)\\s+pr\\s+checkout.*") and
      (
        (containsHeadRef(cmd) or containsPullRequestNumber(cmd))
        or
        exists(string varname |
          (
            containsHeadRef(this.getInScopeEnvVarExpr(varname).getExpression()) or
            containsPullRequestNumber(this.getInScopeEnvVarExpr(varname).getExpression())
          ) and
          exists(cmd.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}

/** Checkout of a Pull Request HEAD ref using gh within a Run step */
class GhSHACheckout extends SHACheckoutStep instanceof Run {
  GhSHACheckout() {
    exists(string cmd | this.getScript().getACommand() = cmd |
      cmd.regexpMatch("gh\\s+pr\\s+checkout.*") and
      (
        containsHeadSHA(cmd)
        or
        exists(string varname |
          containsHeadSHA(this.getInScopeEnvVarExpr(varname).getExpression()) and
          exists(cmd.regexpFind(varname, _, _))
        )
      )
    )
  }

  override string getPath() { result = this.(Run).getWorkingDirectory() }
}
