import actions
import codeql.actions.DataFlow

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
            "\\benv\\.GITHUB_HEAD_REF\\b",
          ], _, _)
  )
}

/** Checkout of a Pull Request HEAD */
abstract class PRHeadCheckoutStep extends Step { }

/** Checkout of a Pull Request HEAD ref */
abstract class MutableRefCheckoutStep extends PRHeadCheckoutStep { }

/** Checkout of a Pull Request HEAD ref */
abstract class SHACheckoutStep extends PRHeadCheckoutStep { }

/** Checkout of a Pull Request HEAD ref using actions/checkout action */
class ActionsMutableRefCheckout extends MutableRefCheckoutStep instanceof UsesStep {
  ActionsMutableRefCheckout() {
    this.getCallee() = "actions/checkout" and
    (
      // ref argument contains the PR id/number or head ref/sha
      exists(Expression e |
        (
          containsHeadRef(e.getExpression()) or
          containsPullRequestNumber(e.getExpression())
        ) and
        DataFlow::hasLocalFlowExpr(e, this.getArgumentExpr("ref"))
      )
      or
      // 3rd party actions returning the PR head sha/ref
      exists(UsesStep step |
        (
          step.getCallee() =
            [
              "eficode/resolve-pr-refs", "xt0rted/pull-request-comment-branch",
              "alessbell/pull-request-comment-branch", "gotson/pull-request-comment-branch"
            ] and
          // TODO: This should be read step of the head_sha or head_ref output vars
          this.getArgument("ref").matches("%.head_ref%")
          or
          step.getCallee() = ["github/branch-deploy"] and
          // TODO: This should be read step of the ref output var
          this.getArgument("ref").matches("%.ref%")
        ) and
        DataFlow::hasLocalFlowExpr(step, this.getArgumentExpr("ref"))
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
    )
  }
}

/** Checkout of a Pull Request HEAD ref using actions/checkout action */
class ActionsSHACheckout extends SHACheckoutStep instanceof UsesStep {
  ActionsSHACheckout() {
    this.getCallee() = "actions/checkout" and
    (
      // ref argument contains the PR id/number or head ref/sha
      exists(Expression e |
        containsHeadSHA(e.getExpression()) and
        DataFlow::hasLocalFlowExpr(e, this.getArgumentExpr("ref"))
      )
      or
      // 3rd party actions returning the PR head sha/ref
      exists(UsesStep step |
        step.getCallee() = ["eficode/resolve-pr-refs", "xt0rted/pull-request-comment-branch"] and
        this.getArgument("ref").regexpMatch(".*head_sha.*") and
        DataFlow::hasLocalFlowExpr(step, this.getArgumentExpr("ref"))
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
    )
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
}

/** Checkout of a Pull Request HEAD ref using gh within a Run step */
class GhMutableRefCheckout extends MutableRefCheckoutStep instanceof Run {
  GhMutableRefCheckout() {
    exists(string line |
      this.getScript().splitAt("\n") = line and
      line.regexpMatch(".*gh\\s+pr\\s+checkout.*") and
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
}

/** An If node that contains an actor, user or label check */
abstract class ControlCheck extends If {
  predicate dominates(Step step) {
    step.getIf() = this or
    step.getEnclosingJob().getIf() = this or
    step.getEnclosingJob().getANeededJob().(LocalJob).getAStep().getIf() = this or
    step.getEnclosingJob().getANeededJob().(LocalJob).getIf() = this
  }
}

class LabelControlCheck extends ControlCheck {
  LabelControlCheck() {
    // eg: contains(github.event.pull_request.labels.*.name, 'safe to test')
    // eg: github.event.label.name == 'safe to test'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind([
              "\\bgithub\\.event\\.pull_request\\.labels\\b", "\\bgithub\\.event\\.label\\.name\\b"
            ], _, _)
    )
  }
}

class ActorControlCheck extends ControlCheck {
  ActorControlCheck() {
    // eg: github.actor == 'dependabot[bot]'
    // eg: github.triggering_actor == 'CI Agent'
    // eg: github.event.pull_request.user.login == 'mybot'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind([
              "\\bgithub\\.actor\\b", "\\bgithub\\.triggering_actor\\b",
              "\\bgithub\\.event\\.comment\\.user\\.login\\b",
              "\\bgithub\\.event\\.pull_request\\.user\\.login\\b",
            ], _, _)
    )
  }
}

class RepositoryControlCheck extends ControlCheck {
  RepositoryControlCheck() {
    // eg: github.repository == 'test/foo'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind(["\\bgithub\\.repository\\b", "\\bgithub\\.repository_owner\\b",], _, _)
    )
  }
}

class AssociationControlCheck extends ControlCheck {
  AssociationControlCheck() {
    // eg: contains(fromJson('["MEMBER", "OWNER"]'), github.event.comment.author_association)
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind([
              "\\bgithub\\.event\\.comment\\.author_association\\b",
              "\\bgithub\\.event\\.issue\\.author_association\\b",
              "\\bgithub\\.event\\.pull_request\\.author_association\\b",
            ], _, _)
    )
  }
}
