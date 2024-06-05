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

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, LocalJob j, Event e
where
  j.getATriggerEvent() = e and
  // job can be triggered by an external user
  e.isExternallyTriggerable() and
  (
    // the workflow runs in the context of the default branch
    runsOnDefaultBranch(e)
    or
    // the workflow caller runs in the context of the default branch
    e.getName() = "workflow_call" and
    exists(ExternalJob caller |
      caller.getCallee() = j.getLocation().getFile().getRelativePath() and
      runsOnDefaultBranch(caller.getATriggerEvent())
    )
  ) and
  // excluding privileged workflows since they can be exploited in easier circumstances
  not j.isPrivileged() and
  CodeInjectionFlow::flowPath(source, sink) and
  j = sink.getNode().asExpr().getEnclosingJob()
select sink.getNode(), source, sink,
  "Unprivileged code injection in $@, which may lead to cache poisoning.", sink,
  sink.getNode().asExpr().(Expression).getRawExpression()
