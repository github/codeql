/**
 * @name Secrets inherited by reusable workflow
 * @description Using `secrets: inherit` passes all parent secrets to a reusable workflow,
 *              violating the principle of least privilege.
 * @kind problem
 * @precision high
 * @security-severity 5.0
 * @problem.severity warning
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
  "All parent secrets are unconditionally inherited by the reusable workflow $@. Pass only the secrets that are needed.",
  job.(Uses).getCalleeNode(), job.(Uses).getCallee()
