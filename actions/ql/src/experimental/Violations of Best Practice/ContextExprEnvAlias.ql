/**
 * @name Redundant environment definitions from context expressions
 * @description This query identifies environment definitions from context
 *              expressions that are redundant because the same information
 *              is already available via predefined environment variables.
 * @kind problem
 * @problem.severity recommendation
 * @id actions/context-expr-env-alias
 */

import actions
import codeql.actions.ast.internal.Ast

// FIXME: No support for ${{ runner.* }} expressions?
class ProvidedGitHubExpressionImpl extends GitHubExpressionImpl {
  ProvidedGitHubExpressionImpl() {
    // Only consider fields that are provided as environment variables.
    this.getFieldName() in [
      "action", "action_path", "action_repository", "actor", "actor_id",
      "api_url", "base_ref", "event_name", "event_path", "graphql_url",
      "head_ref", "job", "ref", "ref_name", "ref_protected", "ref_type",
      "repository", "repository_id", "repository_owner", "repository_owner_id",
      "retention_days", "run_attempt", "run_id", "run_number", "server_url",
      "sha", "triggering_actor", "workflow", "workflow_ref", "workflow_sha",
      "workspace"
    ]
    // Ignore instances in which the github context is used in a
    // larger expression: ${{ inputs.sha || github.sha }}
    // FIXME: No child nodes of GitHubExpressionImpl (e.g. LogicalOrExpression)?
    and this.getFullExpression() = "github." + this.getFieldName()
  }

  string getProvidedEnvVarName() {
      result = "GITHUB_" + this.getFieldName().toUpperCase()
  }
}

from EnvImpl env, ProvidedGitHubExpressionImpl ctx
where env.getAnEnvVarValue() = ctx.getParentNode()
  // Ignore instances in which the github context is used 
  // in string interpolation of an environment variable:
  // env:
  //   FOO: hello ${{ github.actor }}
  and env.getAnEnvVarValue().getValue() = ctx.getRawExpression()
select ctx, "The context expression '" + ctx.getFullExpression() + "' is already defined as the environment variable '" + ctx.getProvidedEnvVarName() + "'."