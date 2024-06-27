import actions

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

