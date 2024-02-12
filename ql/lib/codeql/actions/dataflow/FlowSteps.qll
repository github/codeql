/**
 * Provides classes representing various flow steps for taint tracking.
 */

import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow
import codeql.actions.dataflow.ExternalFlow

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to all
 * taint configurations.
 */
class AdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for all configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/**
 * MaD summaries
 * Fields:
 *    - action: Fully-qualified action name (NWO)
 *    - version: Either '*' or a specific SHA/Tag
 *    - input arg: From node (prefixed with either `env.` or `input.`)
 *    - output arg: To node (prefixed with either `env.` or `output.`)
 *    - kind: Either 'Taint' or 'Value'
 */
predicate externallyDefinedSummary(DataFlow::Node pred, DataFlow::Node succ) {
  exists(UsesExpr uses, string action, string version, string input |
    // `output` not used yet
    summaryModel(action, version, input, _, "taint") and
    uses.getCallee() = action and
    (
      if version.trim() = "*"
      then uses.getVersion() = any(string v)
      else uses.getVersion() = version.trim()
    ) and
    (
      if input.trim().matches("env.%")
      then pred.asExpr() = uses.getEnvExpr(input.trim().replaceAll("env\\.", ""))
      else
        // 'input.' is the default qualifier
        pred.asExpr() = uses.getArgumentExpr(input.trim().replaceAll("input\\.", ""))
    ) and
    succ.asExpr() = uses
  )
}

private class ExternallyDefinedSummary extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    externallyDefinedSummary(pred, succ)
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it in its script and sets an output in its script.
 * e.g.
 *  - name: Extract and Clean Initial URL
 *    id: extract-url
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      INITIAL_URL=$(echo "$BODY" | grep -o 'https://github.com/github/release-assets/assets/[^ >]*')
 *      echo "Cleaned Initial URL: $INITIAL_URL"
 *      echo "::set-output name=initial_url::$INITIAL_URL"
 */
private class RunEnvToScriptStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    runEnvToScriptstep(pred, succ)
  }
}

predicate runEnvToScriptstep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(RunExpr r, string varName |
    r.getEnvExpr(varName) = pred.asExpr() and
    exists(string script, string line |
      script = r.getScript() and
      line = script.splitAt("\n") and
      (
        line.regexpMatch(".*::set-output\\s+name.*") or
        line.regexpMatch(".*>>\\s*\\$GITHUB_OUTPUT.*")
      ) and
      script.indexOf("$" + ["", "{", "ENV{"] + varName) > 0
    ) and
    succ.asExpr() = r
  )
}
