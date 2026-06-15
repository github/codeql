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
  event = getRelevantEventInPrivilegedContext(sink.getNode())
select source.getNode(), source, sink,
  "Potential artifact poisoning; the artifact being consumed has contents that may be controlled by an external user ($@).",
  event, event.getName()
