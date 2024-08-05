import actions
import codeql.actions.config.Config
import codeql.actions.Helper

string defaultBranchTriggerEvent() {
  result =
    [
      "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork", "gollum",
      "issue_comment", "issues", "label", "milestone", "project", "project_card", "project_column",
      "public", "pull_request_comment", "pull_request_target", "repository_dispatch", "schedule",
      "watch", "workflow_run"
    ]
}

predicate runsOnDefaultBranch(Event e) {
  (
    e.getName() = defaultBranchTriggerEvent() and
    not e.getName() = "pull_request_target"
    or
    e.getName() = "push" and
    e.getAPropertyValue("branches") = defaultBranchNames()
    or
    e.getName() = "pull_request_target" and
    (
      // no filtering
      not e.hasProperty("branches") and not e.hasProperty("branches-ignore")
      or
      // only branches-ignore filter
      e.hasProperty("branches-ignore") and
      not e.hasProperty("branches") and
      not e.getAPropertyValue("branches-ignore") = defaultBranchNames()
      or
      // only branches filter
      e.hasProperty("branches") and
      not e.hasProperty("branches-ignore") and
      e.getAPropertyValue("branches") = defaultBranchNames()
      or
      // branches and branches-ignore filters
      e.hasProperty("branches") and
      e.hasProperty("branches-ignore") and
      e.getAPropertyValue("branches") = defaultBranchNames() and
      not e.getAPropertyValue("branches-ignore") = defaultBranchNames()
    )
  )
}

abstract class CacheWritingStep extends Step {
  abstract string getPath();
}

class CacheActionUsesStep extends CacheWritingStep, UsesStep {
  CacheActionUsesStep() { this.getCallee() = "actions/cache" }

  override string getPath() {
    if exists(this.(UsesStep).getArgument("path"))
    then result = this.(UsesStep).getArgument("path").splitAt("\n")
    else result = "?"
  }
}

class CacheActionSaveUsesStep extends CacheWritingStep, UsesStep {
  CacheActionSaveUsesStep() { this.getCallee() = "actions/cache/save" }

  override string getPath() {
    if exists(this.(UsesStep).getArgument("path"))
    then result = this.(UsesStep).getArgument("path").splitAt("\n")
    else result = "?"
  }
}

class SetupJavaUsesStep extends CacheWritingStep, UsesStep {
  SetupJavaUsesStep() {
    this.getCallee() = "actions/setup-java" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
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

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
}

class SetupNodeUsesStep extends CacheWritingStep, UsesStep {
  SetupNodeUsesStep() {
    this.getCallee() = "actions/setup-node" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
}

class SetupPythonUsesStep extends CacheWritingStep, UsesStep {
  SetupPythonUsesStep() {
    this.getCallee() = "actions/setup-python" and
    (
      exists(this.getArgument("cache")) or
      exists(this.getArgument("cache-dependency-path"))
    )
  }

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
}

class SetupDotnetUsesStep extends CacheWritingStep, UsesStep {
  SetupDotnetUsesStep() {
    this.getCallee() = "actions/setup-dotnet" and
    (
      this.getArgument("cache") = "true" or
      exists(this.getArgument("cache-dependency-path"))
    )
  }

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
}

class SetupRubyUsesStep extends CacheWritingStep, UsesStep {
  SetupRubyUsesStep() {
    this.getCallee() = ["actions/setup-ruby", "ruby/setup-ruby"] and
    this.getArgument("bundler-cache") = "true"
  }

  // TODO: Try to get the actual path being cached
  override string getPath() { result = "?" }
}
