import actions
import codeql.actions.dataflow.ExternalFlow

string defaultBranchTriggerEvent() {
  result =
    [
      "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork", "gollum",
      "issue_comment", "issues", "label", "milestone", "project", "project_card", "project_column",
      "public", "pull_request_comment", "pull_request_target", "repository_dispatch", "schedule",
      "watch", "workflow_run"
    ]
}

predicate runsOnDefaultBranch(Job j) {
  exists(Event e |
    j.getATriggerEvent() = e and
    exists(string default_branch_name |
      repositoryDataModel(_, default_branch_name) and
      (
        e.getName() = defaultBranchTriggerEvent() and
        not e.getName() = "pull_request_target"
        or
        e.getName() = "push" and
        e.getAPropertyValue("branches") = default_branch_name
        or
        e.getName() = "pull_request_target" and
        (
          // no filtering
          not e.hasProperty("branches") and not e.hasProperty("branches-ignore")
          or
          // only branches-ignore filter
          e.hasProperty("branches-ignore") and
          not e.hasProperty("branches") and
          not e.getAPropertyValue("branches-ignore") = default_branch_name
          or
          // only branches filter
          e.hasProperty("branches") and
          not e.hasProperty("branches-ignore") and
          e.getAPropertyValue("branches") = default_branch_name
          or
          // branches and branches-ignore filters
          e.hasProperty("branches") and
          e.hasProperty("branches-ignore") and
          e.getAPropertyValue("branches") = default_branch_name and
          not e.getAPropertyValue("branches-ignore") = default_branch_name
        )
      )
    )
  )
  or
  j.getATriggerEvent().getName() = "workflow_call" and
  exists(ExternalJob call |
    call.getCallee() = j.getLocation().getFile().getRelativePath() and
    runsOnDefaultBranch(call)
  )
}

abstract class CacheWritingStep extends Step { }

class CacheActionUsesStep extends CacheWritingStep, UsesStep {
  CacheActionUsesStep() { this.getCallee() = "actions/cache" }
}

class CacheActionSaveUsesStep extends CacheWritingStep, UsesStep {
  CacheActionSaveUsesStep() { this.getCallee() = "actions/cache/save" }
}

class SetupJavaUsesStep extends CacheWritingStep, UsesStep {
  SetupJavaUsesStep() {
    this.getCallee() = "actions/setup-java" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }
}

class SetupGoUsesStep extends CacheWritingStep, UsesStep {
  SetupGoUsesStep() {
    this.getCallee() = "actions/setup-go" and
    (
      not exists(this.getArgument("cache"))
      or
      this.getArgument("cache") = "true"
    )
  }
}

class SetupNodeUsesStep extends CacheWritingStep, UsesStep {
  SetupNodeUsesStep() {
    this.getCallee() = "actions/setup-node" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }
}

class SetupPythonUsesStep extends CacheWritingStep, UsesStep {
  SetupPythonUsesStep() {
    this.getCallee() = "actions/setup-python" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }
}

class SetupDotnetUsesStep extends CacheWritingStep, UsesStep {
  SetupDotnetUsesStep() {
    this.getCallee() = "actions/setup-dotnet" and
    (
      this.getArgument("cache") = "true" or
      exists(this.getArgument("cache-dependency-path"))
    )
  }
}

class SetupRubyUsesStep extends CacheWritingStep, UsesStep {
  SetupRubyUsesStep() {
    this.getCallee() = ["actions/setup-ruby", "ruby/setup-ruby"] and
    this.getArgument("bundler-cache") = "true"
  }
}
