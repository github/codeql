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

/**
 * Holds if `e` can run in the default-branch cache scope.
 * A pull request closed by a merge uses its base branch instead of its merge ref.
 */
predicate runsOnDefaultBranch(Event e) {
  (
    e.getName() = defaultBranchTriggerEvent() and
    not e.getName() = "pull_request_target"
    or
    (
      e.getName() = "push" and
      (
        e.hasProperty(["branches", "branches-ignore"])
        or
        not e.hasProperty(["tags", "tags-ignore"])
      )
      or
      e.getName() = "pull_request_target"
      or
      e.getName() = "pull_request" and e.getAnActivityType() = "closed"
    ) and
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

private string getDeclaredCacheMode(Job job) {
  result = job.getCacheMode()
  or
  not exists(job.getCacheMode()) and
  result = job.getWorkflow().getCacheMode()
}

private predicate cacheModeIsAllowed(string mode, string inheritedMode) {
  mode = ["read", "write", "write-only", "none"] and
  inheritedMode = ["default", "read", "write", "write-only", "none"] and
  (inheritedMode = ["default", "write"] or mode = ["none", inheritedMode])
}

/**
 * Gets the effective declared cache mode, or `default` if no mode was declared in the call chain.
 * An event's implicit default does not limit the modes a reusable workflow can request.
 * Both the callee's workflow-level mode and its job-level modes must fit the caller's explicit limit.
 */
private string getEffectiveCacheMode(Job job, Event event) {
  exists(string inheritedMode |
    (
      job.getWorkflow().getOn().getAnEvent() = event and
      not event.getName() = "workflow_call" and
      inheritedMode = "default"
      or
      inheritedMode =
        getEffectiveCacheMode(job.getWorkflow().(ReusableWorkflow).getACaller(), event)
    )
  |
    (
      not exists(job.getWorkflow().getCacheMode())
      or
      cacheModeIsAllowed(job.getWorkflow().getCacheMode(), inheritedMode)
    ) and
    if exists(getDeclaredCacheMode(job))
    then
      result = getDeclaredCacheMode(job) and
      cacheModeIsAllowed(result, inheritedMode)
    else result = inheritedMode
  )
}

/**
 * Holds if `job` can write to the cache scope of the default branch for `event`.
 * Job cache modes override workflow cache modes, subject to explicit limits from reusable workflow
 * callers. Trigger-based defaults apply only if no cache mode was declared in the call chain.
 */
predicate hasDefaultBranchCacheWriteAccess(LocalJob job, Event event) {
  job.getATriggerEvent() = event and
  runsOnDefaultBranch(event) and
  exists(string mode | mode = getEffectiveCacheMode(job, event) |
    mode = ["write", "write-only"]
    or
    mode = "default" and event.getName() = defaultBranchCacheWriteEvent()
  )
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
