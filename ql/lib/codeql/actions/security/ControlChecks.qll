import actions

/** An If node that contains an actor, user or label check */
abstract class ControlCheck extends AstNode {
  ControlCheck() {
    this instanceof If or
    this instanceof Environment or
    this instanceof UsesStep
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
}

abstract class AssociationCheck extends ControlCheck { }

abstract class ActorCheck extends ControlCheck { }

abstract class RepositoryCheck extends ControlCheck { }

abstract class LabelCheck extends ControlCheck { }

abstract class PermissionCheck extends ControlCheck { }

class EnvironmentCheck extends ControlCheck instanceof Environment {
  EnvironmentCheck() { any() }
}

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
