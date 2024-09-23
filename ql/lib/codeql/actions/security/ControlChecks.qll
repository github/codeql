import actions

string any_relevant_category() {
  result =
    [
      "untrusted-checkout", "output-clobbering", "envpath-injection", "envvar-injection",
      "command-injection", "argument-injection", "code-injection", "cache-poisoning",
      "untrusted-checkout-toctou", "artifact-poisoning"
    ]
}

string any_non_toctou_category() {
  result = any_relevant_category() and not result = "untrusted-checkout-toctou"
}

string any_relevant_event() {
  result =
    [
      "pull_request_target",
      "issue_comment",
      "pull_request_comment",
      "workflow_run",
      "issues",
      "fork",
      "watch",
      "discussion_comment",
      "discussion"
    ]
}

/** An If node that contains an actor, user or label check */
abstract class ControlCheck extends AstNode {
  ControlCheck() {
    this instanceof If or
    this instanceof Environment or
    this instanceof UsesStep or
    this instanceof Run
  }

  predicate protects(Step step, Event event, string category) {
    event.getEnclosingWorkflow() = step.getEnclosingWorkflow() and
    this.dominates(step) and
    this.protectsCategoryAndEvent(category, event.getName())
  }

  predicate dominates(Step step) {
    this instanceof If and
    (
      step.getIf() = this or
      step.getEnclosingJob().getIf() = this or
      step.getEnclosingJob().getANeededJob().(LocalJob).getAStep().getIf() = this or
      step.getEnclosingJob().getANeededJob().(LocalJob).getIf() = this
    )
    or
    this instanceof Environment and
    (
      step.getEnclosingJob().getEnvironment() = this
      or
      step.getEnclosingJob().getANeededJob().getEnvironment() = this
    )
    or
    (
      this instanceof Run or
      this instanceof UsesStep
    ) and
    (
      this.(Step).getAFollowingStep() = step
      or
      step.getEnclosingJob().getANeededJob().(LocalJob).getAStep() = this.(Step)
    )
  }

  abstract predicate protectsCategoryAndEvent(string category, string event);
}

abstract class AssociationCheck extends ControlCheck {
  // Checks if the actor is a MEMBER/OWNER the repo
  // - they are effective against pull requests and workflow_run (since these are triggered by pull_requests) since they can control who is making the PR
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run"] and category = any_relevant_category()
  }
}

abstract class ActorCheck extends ControlCheck {
  // checks for a specific actor
  // - they are effective against pull requests and workflow_run (since these are triggered by pull_requests) since they can control who is making the PR
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run"] and category = any_relevant_category()
  }
}

abstract class RepositoryCheck extends ControlCheck {
  // checks that the origin of the code is the same as the repository.
  // for pull_requests, that means that it triggers only on local branches or repos from the same org
  // - they are effective against pull requests/workflow_run since they can control where the code is coming from
  // - they are not effective against issue_comment since the repository will always be the same
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run"] and category = any_relevant_category()
  }
}

abstract class PermissionCheck extends ControlCheck {
  // checks that the actor has a specific permission level
  // - they are effective against pull requests/workflow_run since they can control who can make changes
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run", "issue_comment"] and
    category = any_relevant_category()
  }
}

abstract class LabelCheck extends ControlCheck {
  // checks if the issue/pull_request is labeled, which implies that it could have been approved
  // - they dont protect against mutation attacks
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run"] and category = any_non_toctou_category()
  }
}

class EnvironmentCheck extends ControlCheck instanceof Environment {
  // Environment checks are not effective against any mutable attacks
  // they do actually protect against untrusted code execution (sha)
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = ["pull_request_target", "workflow_run"] and category = any_non_toctou_category()
  }
}

abstract class CommentVsHeadDateCheck extends ControlCheck {
  override predicate protectsCategoryAndEvent(string category, string event) {
    // by itself, this check is not effective against any attacks
    none()
  }
}

/* Specific implementations of control checks */
class LabelIfCheck extends LabelCheck instanceof If {
  LabelIfCheck() {
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

class ActorIfCheck extends ActorCheck instanceof If {
  ActorIfCheck() {
    // eg: github.event.pull_request.user.login == 'admin'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind([
              "\\bgithub\\.event\\.pull_request\\.user\\.login\\b",
              "\\bgithub\\.event\\.head_commit\\.author\\.name\\b",
              "\\bgithub\\.event\\.commits.*\\.author\\.name\\b"
            ], _, _)
    )
    or
    // eg: github.actor == 'admin'
    // eg: github.triggering_actor == 'admin'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind(["\\bgithub\\.actor\\b", "\\bgithub\\.triggering_actor\\b",], _, _)
    ) and
    not normalizeExpr(this.getCondition()).matches("%[bot]%")
  }
}

class RepositoryIfCheck extends RepositoryCheck instanceof If {
  RepositoryIfCheck() {
    // eg: github.repository == 'test/foo'
    exists(
      normalizeExpr(this.getCondition())
          // github.repository in a workflow_run event triggered by a pull request is the base repository
          .regexpFind([
              "\\bgithub\\.repository\\b", "\\bgithub\\.repository_owner\\b",
              "\\bgithub\\.event\\.pull_request\\.head\\.repo\\.full_name\\b",
              "\\bgithub\\.event\\.pull_request\\.head\\.repo\\.owner\\.name\\b",
              "\\bgithub\\.event\\.workflow_run\\.head_repository\\.full_name\\b",
              "\\bgithub\\.event\\.workflow_run\\.head_repository\\.owner\\.name\\b"
            ], _, _)
    )
  }
}

class AssociationIfCheck extends AssociationCheck instanceof If {
  AssociationIfCheck() {
    // eg: contains(fromJson('["MEMBER", "OWNER"]'), github.event.comment.author_association)
    normalizeExpr(this.getCondition())
        .splitAt("\n")
        .regexpMatch([
            ".*\\bgithub\\.event\\.comment\\.author_association\\b.*",
            ".*\\bgithub\\.event\\.issue\\.author_association\\b.*",
            ".*\\bgithub\\.event\\.pull_request\\.author_association\\b.*",
          ])
  }
}

class AssociationActionCheck extends AssociationCheck instanceof UsesStep {
  AssociationActionCheck() {
    this.getCallee() = "TheModdingInquisition/actions-team-membership" and
    (
      not exists(this.getArgument("exit"))
      or
      this.getArgument("exit") = "true"
    )
  }
}

class PermissionActionCheck extends PermissionCheck instanceof UsesStep {
  PermissionActionCheck() {
    this.getCallee() = "sushichop/action-repository-permission" and
    this.getArgument("required-permission") = ["write", "admin"]
    or
    this.getCallee() = "prince-chrismc/check-actor-permissions-action" and
    this.getArgument("permission") = ["write", "admin"]
    or
    this.getCallee() = "lannonbr/repo-permission-check-action" and
    this.getArgument("permission") = ["write", "admin"]
    or
    this.getCallee() = "xt0rted/slash-command-action" and
    (
      // default permission level is write
      not exists(this.getArgument("permission-level")) or
      this.getArgument("permission-level") = ["write", "admin"]
    )
  }
}

class BashCommentVsHeadDateCheck extends CommentVsHeadDateCheck, Run {
  BashCommentVsHeadDateCheck() {
    exists(string line |
      line = this.getScript().splitAt("\n") and
      line.toLowerCase()
          .regexpMatch(".*date\\s+-d.*(commit_at|pushed_at|comment_at|commented_at).*date\\s+-d.*(commit_at|pushed_at|comment_at|commented_at).*")
    )
  }
}
