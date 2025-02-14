/**
 * @name Artifact poisoning
 * @description An attacker may be able to poison the workflow's artifacts and influence on consequent steps.
 * @kind path-problem
 * @problem.severity error
 * @precision very-high
 * @security-severity 9
 * @id actions/artifact-poisoning/critical
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery
import ArtifactPoisoningFlow::PathGraph
import codeql.actions.security.ControlChecks

from ArtifactPoisoningFlow::PathNode source, ArtifactPoisoningFlow::PathNode sink, Event event
where
  ArtifactPoisoningFlow::flowPath(source, sink) and
  inPrivilegedContext(sink.getNode().asExpr(), event) and
  not exists(ControlCheck check |
    check.protects(sink.getNode().asExpr(), event, "artifact-poisoning")
  )
select sink.getNode(), source, sink,
  "Potential artifact poisoning in $@, which may be controlled by an external user ($@).", sink,
  sink.getNode().toString(), event, event.getName()
