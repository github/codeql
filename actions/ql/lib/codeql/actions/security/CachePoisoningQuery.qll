import actions

string defaultBranchTriggerEvent() {
  result =
    [
      "check_run", "check_suite", "delete", "discussion", "discussion_comment", "fork", "gollum",
      "issue_comment", "issues", "label", "milestone", "project", "project_card", "project_column",
      "public", "pull_request_comment", "pull_request_target", "repository_dispatch",
      "registry_package", "page_build", "schedule", "watch", "workflow_dispatch", "workflow_run"
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

private string defaultBranchCacheWriteEvent() {
  result =
    [
      "push", "workflow_dispatch", "repository_dispatch", "delete", "registry_package",
      "page_build", "schedule"
    ]
}

private predicate eventHasDefaultBranchCacheWriteAccess(Event event) {
  runsOnDefaultBranch(event) and event.getName() = defaultBranchCacheWriteEvent()
}

/**
 * Holds if `job` can write to the cache scope of the default branch for `event`.
 * Reusable workflow jobs inherit their caller's trigger event.
 */
predicate hasDefaultBranchCacheWriteAccess(LocalJob job, Event event) {
  job.getATriggerEvent() = event and
  eventHasDefaultBranchCacheWriteAccess(event)
}

abstract class CacheWritingStep extends Step {
  abstract string getPath();
}

class CacheActionUsesStep extends CacheWritingStep, UsesStep {
  CacheActionUsesStep() { this.getCallee() = "actions/cache" }

  override string getPath() {
    result = normalizePath(this.(UsesStep).getArgument("path").splitAt("\n"))
  }
}

class CacheActionSaveUsesStep extends CacheWritingStep, UsesStep {
  CacheActionSaveUsesStep() { this.getCallee() = "actions/cache/save" }

  override string getPath() {
    result = normalizePath(this.(UsesStep).getArgument("path").splitAt("\n"))
  }
}

class SetupRubyUsesStep extends CacheWritingStep, UsesStep {
  SetupRubyUsesStep() {
    this.getCallee() = ["actions/setup-ruby", "ruby/setup-ruby"] and
    this.getArgument("bundler-cache") = "true"
  }

  override string getPath() { result = normalizePath("vendor/bundle") }
}
