import actions

string any_category() {
  result =
    [
      "untrusted-checkout", "output-clobbering", "envpath-injection", "envvar-injection",
      "command-injection", "argument-injection", "code-injection", "cache-poisoning",
      "untrusted-checkout-toctou", "artifact-poisoning", "artifact-poisoning-toctou"
    ]
}

string non_toctou_category() {
  result = any_category() and not result = "untrusted-checkout-toctou"
}

string toctou_category() { result = ["untrusted-checkout-toctou", "artifact-poisoning-toctou"] }

string any_event() { result = actor_not_attacker_event() or result = actor_is_attacker_event() }

string actor_is_attacker_event() {
  result =
    [
      // actor and attacker have to be the same
      "pull_request_target",
      "workflow_run",
      "discussion_comment",
      "discussion",
      "issues",
      "fork",
      "watch"
    ]
}

string actor_not_attacker_event() {
  result =
    [
      // actor and attacker can be different
      // actor may be a collaborator, but the attacker is may be the author of the PR that gets commented
      // therefore it may be vulnerable to TOCTOU races where the actor reviews one thing and the attacker changes it
      "issue_comment",
      "pull_request_comment",
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

  predicate protects(AstNode node, Event event, string category) {
    // The check dominates the step it should protect
    this.dominates(node) and
    // The check is effective against the event and category
    this.protectsCategoryAndEvent(category, event.getName()) and
    // The check can be triggered by the event
    this.getATriggerEvent() = event
  }

  predicate dominates(AstNode node) {
    this instanceof If and
    (
      node.getEnclosingStep().getIf() = this or
      node.getEnclosingJob().getIf() = this or
      node.getEnclosingJob().getANeededJob().(LocalJob).getAStep().getIf() = this or
      node.getEnclosingJob().getANeededJob().(LocalJob).getIf() = this
    )
    or
    this instanceof Environment and
    (
      node.getEnclosingJob().getEnvironment() = this
      or
      node.getEnclosingJob().getANeededJob().getEnvironment() = this
    )
    or
    (
      this instanceof Run or
      this instanceof UsesStep
    ) and
    (
      this.(Step).getAFollowingStep() = node.getEnclosingStep()
      or
      node.getEnclosingJob().getANeededJob().(LocalJob).getAStep() = this.(Step)
    )
  }

  abstract predicate protectsCategoryAndEvent(string category, string event);
}

abstract class AssociationCheck extends ControlCheck {
  // Checks if the actor is a MEMBER/OWNER the repo
  // - they are effective against pull requests and workflow_run (since these are triggered by pull_requests) since they can control who is making the PR
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = actor_is_attacker_event() and category = any_category()
    or
    event = actor_not_attacker_event() and category = non_toctou_category()
  }
}

abstract class ActorCheck extends ControlCheck {
  // checks for a specific actor
  // - they are effective against pull requests and workflow_run (since these are triggered by pull_requests) since they can control who is making the PR
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = actor_is_attacker_event() and category = any_category()
    or
    event = actor_not_attacker_event() and category = non_toctou_category()
  }
}

abstract class RepositoryCheck extends ControlCheck {
  // checks that the origin of the code is the same as the repository.
  // for pull_requests, that means that it triggers only on local branches or repos from the same org
  // - they are effective against pull requests/workflow_run since they can control where the code is coming from
  // - they are not effective against issue_comment since the repository will always be the same
}

abstract class PermissionCheck extends ControlCheck {
  // checks that the actor has a specific permission level
  // - they are effective against pull requests/workflow_run since they can control who can make changes
  // - they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = actor_is_attacker_event() and category = any_category()
    or
    event = actor_not_attacker_event() and category = non_toctou_category()
  }
}

abstract class LabelCheck extends ControlCheck {
  // checks if the issue/pull_request is labeled, which implies that it could have been approved
  // - they dont protect against mutation attacks
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = actor_is_attacker_event() and category = any_category()
    or
    event = actor_not_attacker_event() and category = non_toctou_category()
  }
}

class EnvironmentCheck extends ControlCheck instanceof Environment {
  // Environment checks are not effective against any mutable attacks
  // they do actually protect against untrusted code execution (sha)
  override predicate protectsCategoryAndEvent(string category, string event) {
    event = actor_is_attacker_event() and category = any_category()
    or
    event = actor_not_attacker_event() and category = non_toctou_category()
  }
}

abstract class CommentVsHeadDateCheck extends ControlCheck {
  override predicate protectsCategoryAndEvent(string category, string event) {
    // by itself, this check is not effective against any attacks
    event = actor_not_attacker_event() and category = toctou_category()
  }
}

/* Specific implementations of control checks */
class LabelIfCheck extends LabelCheck instanceof If {
  string condition;

  LabelIfCheck() {
    condition = normalizeExpr(this.getCondition()) and
    (
      // eg: contains(github.event.pull_request.labels.*.name, 'safe to test')
      condition.regexpMatch(".*(^|[^!])contains\\(\\s*github\\.event\\.pull_request\\.labels\\b.*")
      or
      // eg: github.event.label.name == 'safe to test'
      condition.regexpMatch(".*\\bgithub\\.event\\.label\\.name\\s*==.*")
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
              "\\bgithub\\.event\\.commits.*\\.author\\.name\\b",
              "\\bgithub\\.event\\.sender\\.login\\b"
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

class PullRequestTargetRepositoryIfCheck extends RepositoryCheck instanceof If {
  PullRequestTargetRepositoryIfCheck() {
    // eg: github.event.pull_request.head.repo.full_name == github.repository
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

  override predicate protectsCategoryAndEvent(string category, string event) {
    event = "pull_request_target" and category = any_category()
  }
}

class WorkflowRunRepositoryIfCheck extends RepositoryCheck instanceof If {
  WorkflowRunRepositoryIfCheck() {
    // eg: github.event.workflow_run.head_repository.full_name == github.repository
    exists(
      normalizeExpr(this.getCondition())
          // github.repository in a workflow_run event triggered by a pull request is the base repository
          .regexpFind([
              "\\bgithub\\.event\\.workflow_run\\.head_repository\\.full_name\\b",
              "\\bgithub\\.event\\.workflow_run\\.head_repository\\.owner\\.name\\b"
            ], _, _)
    )
  }

  override predicate protectsCategoryAndEvent(string category, string event) {
    event = "workflow_run" and category = any_category()
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
    or
    this.getCallee() = "actions/github-script" and
    this.getArgument("script").splitAt("\n").matches("%getMembershipForUserInOrg%")
    or
    this.getCallee() = "octokit/request-action" and
    this.getArgument("route").regexpMatch("GET.*(memberships).*")
  }
}

class PermissionActionCheck extends PermissionCheck instanceof UsesStep {
  PermissionActionCheck() {
    this.getCallee() = "actions-cool/check-user-permission" and
    (
      // default permission level is write
      not exists(this.getArgument("permission-level")) or
      this.getArgument("require") = ["write", "admin"]
    )
    or
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
    or
    this.getCallee() = "actions/github-script" and
    this.getArgument("script").splitAt("\n").matches("%getCollaboratorPermissionLevel%")
    or
    this.getCallee() = "octokit/request-action" and
    this.getArgument("route").regexpMatch("GET.*(collaborators|permission).*")
  }
}

class BashCommentVsHeadDateCheck extends CommentVsHeadDateCheck, Run {
  BashCommentVsHeadDateCheck() {
    // eg: if [[ $(date -d "$pushed_at" +%s) -gt $(date -d "$COMMENT_AT" +%s) ]]; then
    exists(string cmd1, string cmd2 |
      cmd1 = this.getScript().getACommand() and
      cmd2 = this.getScript().getACommand() and
      not cmd1 = cmd2 and
      cmd1.toLowerCase().regexpMatch("date\\s+-d.*(commit|pushed|comment|commented)_at.*") and
      cmd2.toLowerCase().regexpMatch("date\\s+-d.*(commit|pushed|comment|commented)_at.*")
    )
  }
}
