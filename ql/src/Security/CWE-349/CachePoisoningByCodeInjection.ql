/**
 * @name Cache Poisoning via low-privilege code injection
 * @description The cache can be poisoned by untrusted code, leading to a cache poisoning attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 9.3
 * @id actions/cache-poisoning/code-injection
 * @tags actions
 *       security
 *       external/cwe/cwe-349
 *       external/cwe/cwe-094
 */

import actions
import codeql.actions.security.CodeInjectionQuery
import codeql.actions.security.CachePoisoningQuery
import CodeInjectionFlow::PathGraph

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, LocalJob j
where
  CodeInjectionFlow::flowPath(source, sink) and
  j = sink.getNode().asExpr().getEnclosingJob() and
  not j.isPrivileged() and
  // The workflow runs in the context of the default branch
  // TODO: (require to collect trigger types)
  // - add push to default branch?
  // - exclude pull_request_target when branches_ignore includes default branch or when branches does not include the default branch
  (
    j.getEnclosingWorkflow().hasTriggerEvent(defaultBranchTriggerEvent())
    or
    j.getEnclosingWorkflow().hasTriggerEvent("workflow_call") and
    exists(ExternalJob call, Workflow caller |
      call.getCallee() = j.getLocation().getFile().getRelativePath() and
      caller = call.getWorkflow() and
      caller.hasTriggerEvent(defaultBranchTriggerEvent())
    )
  )
select sink.getNode(), source, sink,
  "Unprivileged code injection in $@, which may lead to cache poisoning.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
