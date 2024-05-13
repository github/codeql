import actions
import codeql.actions.dataflow.ExternalFlow

string selfHostedRunnerRegexp() {
  // source: https://github.com/boostsecurityio/poutine/blob/main/opa/rego/poutine/utils.rego#L49C3-L49C136
  result =
    "(?i)^((ubuntu-(([0-9]{2})\\.04|latest)|macos-([0-9]{2}|latest)(-x?large)?|windows-(20[0-9]{2}|latest)|(buildjet|warp)-[a-z0-9-]+))$"
}

/**
 * This predicate uses data available in the workflow file to identify self-hosted runners.
 * It does not know if the repository is public or private.
 * It is a best-effort approach to identify self-hosted runners.
 */
predicate staticallyIdentifiedSelfHostedRunner(Job job) {
  exists(string label |
    job.getATriggerEvent().getName() =
      ["pull_request", "pull_request_review", "pull_request_review_comment", "pull_request_target"] and
    label = job.getARunsOnLabel() and
    not label.regexpMatch(selfHostedRunnerRegexp())
  )
}

/**
 * This predicate uses data available in the job log files to identify self-hosted runners.
 * It is a best-effort approach to identify self-hosted runners.
 */
predicate dynamicallyIdentifiedSelfHostedRunner(Job job) {
  exists(string runner_info |
    workflowDataModel(job.getEnclosingWorkflow().getLocation().getFile().getRelativePath(),
      "public", job.getId(), _, _, runner_info) and
    runner_info.indexOf("self-hosted:true") > 0
  )
}
