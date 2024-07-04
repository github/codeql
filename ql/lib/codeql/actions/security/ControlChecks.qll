import actions

/** An If node that contains an actor, user or label check */
abstract class ControlCheck extends AstNode {
  ControlCheck() {
    this instanceof If or
    this instanceof Environment or
    this instanceof UsesStep
  }

  predicate protects(Step step, Event event) {
    event.getEnclosingWorkflow() = step.getEnclosingWorkflow() and
    this.getAProtectedEvent() = event.getName() and
    this.dominates(step)
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
    this.(UsesStep).getAFollowingStep() = step
  }

  abstract string getAProtectedEvent();

  abstract boolean protectsAgainstRefMutationAttacks();
}

abstract class AssociationCheck extends ControlCheck {
  // checks who you are (identity)
  // association checks are effective against pull requests since they can control who is making the PR
  // they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  // someone entitled to trigger the workflow with a comment, may no detect a malicious comment, or the comment may mutate after approval
  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  override boolean protectsAgainstRefMutationAttacks() { result = true }
}

abstract class ActorCheck extends ControlCheck {
  // checks who you are (identity)
  // actor checks are effective against pull requests since they can control who is making the PR
  // they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  // someone entitled to trigger the workflow with a comment, may no detect a malicious comment, or the comment may mutate after approval
  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  override boolean protectsAgainstRefMutationAttacks() { result = true }
}

abstract class RepositoryCheck extends ControlCheck {
  // repository checks are effective against pull requests since they can control where the code is coming from
  // they are not effective against issue_comment since the repository will always be the same
  // who you are (identity)
  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  override boolean protectsAgainstRefMutationAttacks() { result = true }
}

abstract class PermissionCheck extends ControlCheck {
  // permission checks are effective against pull requests since they can control who can make changes
  // they are not effective against issue_comment since the author of the comment may not be the same as the author of the PR
  // someone entitled to trigger the workflow with a comment, may no detect a malicious comment, or the comment may mutate after approval
  // who you are (identity)
  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  override boolean protectsAgainstRefMutationAttacks() { result = true }
}


abstract class LabelCheck extends ControlCheck {
  // does it protect injection attacks but not pwn requests?
  // pwn requests are susceptible to checkout of mutable code
  // but injection attacks are not, although a branch name can be changed after approval and perhaps also some other things
  // they do actually protext against untrusted code execution (sha)
  // what you have (approval)
  // TODO: A check should be a combination of:
  // - event type (pull_request, issue_comment, etc)
  // - category (untrusted mutable code, untrusted immutable code, code injection, etc)
  //  - we dont know this unless we pass category to inPrivilegedContext and into ControlCheck.protects
  //  - we can decide if a control check is effective based only on the ast node
  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  // ref can be mutated after approval
  override boolean protectsAgainstRefMutationAttacks() { result = false }
}

class EnvironmentCheck extends ControlCheck instanceof Environment {
  // Environment checks are not effective against any mutable attacks
  // they do actually protext against untrusted code execution (sha)
  // what you have (approval)
  EnvironmentCheck() { any() }

  override string getAProtectedEvent() { result = ["pull_request", "pull_request_target"] }

  // ref can be mutated after approval
  override boolean protectsAgainstRefMutationAttacks() { result = false }
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

class RepositoryIfCheck extends RepositoryCheck instanceof If {
  RepositoryIfCheck() {
    // eg: github.repository == 'test/foo'
    exists(
      normalizeExpr(this.getCondition())
          .regexpFind(["\\bgithub\\.repository\\b", "\\bgithub\\.repository_owner\\b",], _, _)
    )
  }
}

class AssociationIfCheck extends AssociationCheck instanceof If {
  AssociationIfCheck() {
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

class AssociationActionCheck extends AssociationCheck instanceof UsesStep {
  AssociationActionCheck() {
    this.getCallee() = "TheModdingInquisition/actions-team-membership" and
    not exists(this.getArgument("exit"))
    or
    this.getArgument("exit") = "true"
  }
}

class PermissionActionCheck extends PermissionCheck instanceof UsesStep {
  PermissionActionCheck() {
    this.getCallee() = "lannonbr/repo-permission-check-action" and
    not this.getArgument("permission") = ["write", "admin"]
  }
}
