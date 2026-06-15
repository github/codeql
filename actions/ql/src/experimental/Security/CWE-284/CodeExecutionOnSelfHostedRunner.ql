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
 *       experimental
 *       external/cwe/cwe-284
 */

import codeql.actions.security.SelfHostedQuery

from Job job
where staticallyIdentifiedSelfHostedRunner(job) or dynamicallyIdentifiedSelfHostedRunner(job)
select job, "Job runs on self-hosted runner"
