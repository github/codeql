/**
 * @name Pull Request code execution on self-hosted runner
 * @description Running untrusted code on a public repository's self-hosted runner can lead to the compromise of the runner machine
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/pr-on-self-hosted-runner
 * @tags actions
 *       security
 *       external/cwe/cwe-284
 */

import actions
import codeql.actions.dataflow.ExternalFlow

/**
 * This predicate uses data available in the workflow file to identify self-hosted runners.
 * It does not know if the repository is public or private.
 * It is a best-effort approach to identify self-hosted runners.
 */
predicate staticallyIdentifiedSelfHostedRunner(Job job) {
  exists(string label |
    job.getEnclosingWorkflow().getATriggerEvent() =
      ["pull_request", "pull_request_review", "pull_request_review_comment", "pull_request_target"] and
    label = job.getARunsOnLabel() and
    // source: https://github.com/boostsecurityio/poutine/blob/main/opa/rego/poutine/utils.rego#L49C3-L49C136
    not label
        .regexpMatch("(?i)^((ubuntu-(([0-9]{2})\\.04|latest)|macos-([0-9]{2}|latest)(-x?large)?|windows-(20[0-9]{2}|latest)|(buildjet|warp)-[a-z0-9-]+))$")
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
    runner_info.matches("self-hosted:true")
  )
}

from Job job
where staticallyIdentifiedSelfHostedRunner(job) or dynamicallyIdentifiedSelfHostedRunner(job)
select job, "Job runs on self-hosted runner"
