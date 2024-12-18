/**
 * @name Artifact poisoning
 * @description An attacker may be able to poison the workflow's artifacts and influence on consequent steps.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @security-severity 5.0
 * @id actions/artifact-poisoning/medium
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery
import ArtifactPoisoningFlow::PathGraph
import codeql.actions.security.ControlChecks

from ArtifactPoisoningFlow::PathNode source, ArtifactPoisoningFlow::PathNode sink
where
  ArtifactPoisoningFlow::flowPath(source, sink) and
  inNonPrivilegedContext(sink.getNode().asExpr())
select sink.getNode(), source, sink,
  "Potential artifact poisoning in $@, which may be controlled by an external user.", sink,
  sink.getNode().toString()
