/**
 * Provides classes representing various flow steps for taint tracking.
 */

import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow

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
 * Holds if actions-find-and-replace-string step is used.
 */
private class ActionsFindAndReplaceStringStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(UsesExpr u |
      u.getTarget() = "mad9000/actions-find-and-replace-string" and
      pred.asExpr() = u.getArgument(["source", "replace"]) and
      succ.asExpr() = u
    )
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
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) { test(pred, succ) }
}

predicate test(DataFlow::Node pred, DataFlow::Node succ) {
  exists(RunExpr r, string varName |
    r.getEnvExpr(varName) = pred.asExpr() and
    exists(string script, string line |
      script = r.getScript() and
      line = script.splitAt("\n") and
      line.regexpMatch(".*::set-output\\s+name.*") and
      script.indexOf("$" + ["", "{", "ENV{"] + varName) > 0
    ) and
    succ.asExpr() = r
  )
}
