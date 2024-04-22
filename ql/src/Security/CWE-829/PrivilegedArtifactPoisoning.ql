/**
 * @name Artifact poisoning
 * @description An attacker may be able to poison the workflow's artifacts and influence on consequent steps.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @security-severity 9
 * @id actions/privileged-artifact-poisoning
 * @tags actions
 *       security
 *       external/cwe/cwe-829
 */

import actions
import codeql.actions.security.ArtifactPoisoningQuery
import ArtifactPoisoningFlow::PathGraph

from ArtifactPoisoningFlow::PathNode source, ArtifactPoisoningFlow::PathNode sink
where
  ArtifactPoisoningFlow::flowPath(source, sink) and
  exists(Job j |
    j = sink.getNode().asExpr().getEnclosingJob() and
    j.isPrivileged()
  )
select sink.getNode(), source, sink,
  "Potential privileged artifact poisoning in $@, which may be controlled by an external user.",
  sink, sink.getNode().toString()
