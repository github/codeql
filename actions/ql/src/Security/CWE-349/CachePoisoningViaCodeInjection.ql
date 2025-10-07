/**
 * @name Cache Poisoning via low-privileged code injection
 * @description The cache can be poisoned by untrusted code, leading to a cache poisoning attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 7.5
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
import codeql.actions.security.ControlChecks

from CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, Event event
where
  CodeInjectionFlow::flowPath(source, sink) and
  event = getRelevantCachePoisoningEventForSink(sink.getNode()) and
  // the checkout is not controlled by an access check
  not exists(ControlCheck check |
    check.protects(source.getNode().asExpr(), event, "code-injection")
  )
select sink.getNode(), source, sink,
  "Unprivileged code injection in $@, which may lead to cache poisoning ($@).", sink,
  sink.getNode().asExpr().(Expression).getRawExpression(), event, event.getName()
