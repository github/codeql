/**
 * @name Long-lived npm token used in publish step
 * @description The publish step sets NODE_AUTH_TOKEN or NPM_TOKEN from a GitHub Actions secret.
 *              This is a long-lived credential that can be stolen and used to publish malicious
 *              versions from outside the CI/CD pipeline.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/npm-token-in-publish
 * @tags actions
 *       security
 *       supply-chain
 *       external/cwe/cwe-798
 */

import actions

/**
 * Holds if `run` is a Run step whose script contains an `npm publish` or `yarn publish` command.
 */
predicate isNpmPublishStep(Run run) {
  run.getScript().getACommand().regexpMatch("(?i).*\\bnpm\\s+publish\\b.*") or
  run.getScript().getACommand().regexpMatch("(?i).*\\byarn\\s+publish\\b.*")
}

/**
 * Holds if `uses` is a UsesStep that calls a known npm publish action.
 */
predicate isNpmPublishUsesStep(UsesStep uses) {
  uses.getCallee().matches(["JS-DevTools/npm-publish%", "js-devtools/npm-publish%"])
}

/**
 * Holds if `expr` is an expression that references a secret (e.g. `secrets.NPM_TOKEN`).
 */
bindingset[exprValue]
predicate isSecretsReference(string exprValue) {
  exprValue.regexpMatch("(?i)secrets\\..*")
}

from Step publishStep, Env env, string envVarName, Expression secretExpr
where
  (
    isNpmPublishStep(publishStep) or
    isNpmPublishUsesStep(publishStep)
  ) and
  env = publishStep.getEnv() and
  envVarName = ["NODE_AUTH_TOKEN", "NPM_TOKEN"] and
  secretExpr = env.getEnvVarExpr(envVarName) and
  isSecretsReference(secretExpr.getExpression())
select secretExpr,
  "Long-lived npm token '$@' is used in a publish step. Use npm Trusted Publishing (OIDC) instead.",
  secretExpr, envVarName
