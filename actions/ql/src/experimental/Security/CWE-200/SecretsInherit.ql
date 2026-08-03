/**
 * @name Secrets inherited by reusable workflow
 * @description Using `secrets: inherit` passes every secret the calling workflow can access
 *              to a reusable workflow, which is more than most callees need.
 * @kind problem
 * @precision medium
 * @security-severity 3.0
 * @problem.severity recommendation
 * @id actions/secrets-inherit
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-200
 */

import actions
private import codeql.actions.ast.internal.Yaml
private import codeql.actions.ast.internal.Ast

from ExternalJob job, YamlScalar secretsNode
where
  secretsNode = job.(ExternalJobImpl).getNode().lookup("secrets") and
  secretsNode.getValue() = "inherit"
select secretsNode,
  "Every secret accessible to the calling workflow is forwarded to $@. Consider passing only the secrets it actually needs.",
  job.(Uses).getCalleeNode(), job.(Uses).getCallee()
