import actions

bindingset[runner]
predicate isGithubHostedRunner(string runner) {
  // list of github hosted repos: https://github.com/actions/runner-images/blob/main/README.md#available-images
  runner
      .toLowerCase()
      .regexpMatch("^(ubuntu-([0-9.]+|latest)|macos-([0-9]+|latest)(-x?large)?|windows-([0-9.]+|latest))$")
}

bindingset[runner]
predicate is3rdPartyHostedRunner(string runner) {
  runner.toLowerCase().regexpMatch("^(buildjet|warp)-[a-z0-9-]+$")
}

/**
 * This predicate uses data available in the workflow file to identify self-hosted runners.
 * It does not know if the repository is public or private.
 * It is a best-effort approach to identify self-hosted runners.
 */
predicate staticallyIdentifiedSelfHostedRunner(Job job) {
  exists(string label |
    job.getATriggerEvent().getName() =
      [
        "issue_comment", "pull_request", "pull_request_review", "pull_request_review_comment",
        "pull_request_target", "workflow_run"
      ] and
    label = job.getARunsOnLabel() and
    not isGithubHostedRunner(label) and
    not is3rdPartyHostedRunner(label)
  )
}

/**
 * This predicate uses data available in the job log files to identify self-hosted runners.
 * It is a best-effort approach to identify self-hosted runners.
 */
predicate dynamicallyIdentifiedSelfHostedRunner(Job job) {
  exists(string runner_info |
    repositoryDataModel("public", _) and
    workflowDataModel(job.getEnclosingWorkflow().getLocation().getFile().getRelativePath(), _,
      job.getId(), _, _, runner_info) and
    runner_info.indexOf("self-hosted:true") > 0
  )
}
