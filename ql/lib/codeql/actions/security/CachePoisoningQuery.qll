import actions

string defaultBranchTriggerEvent() {
  result =
    [
      "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork", "gollum",
      "issue_comment", "issues", "label", "milestone", "project", "project_card", "project_column",
      "public", "pull_request_comment", "pull_request_target", "repository_dispatch", "schedule",
      "watch", "workflow_run"
    ]
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
