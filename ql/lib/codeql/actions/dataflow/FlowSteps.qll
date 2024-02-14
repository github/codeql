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

// private class RunEnvToScriptStep extends AdditionalTaintStep {
//   override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
//     runEnvToScriptstep(pred, succ)
//   }
// }
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
 *      echo "foo=$(echo $TAINTED)" >> $GITHUB_OUTPUT
 *      echo "test=${{steps.step1.outputs.MSG}}" >> "$GITHUB_OUTPUT"
 */
predicate runEnvToScriptStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(RunExpr r, string varName, string output |
    c = any(DataFlow::FieldContent ct | ct.getName() = output.replaceAll("output\\.", "")) and
    r.getEnvExpr(varName) = pred.asExpr() and
    exists(string script, string line |
      script = r.getScript() and
      line = script.splitAt("\n") and
      (
        output = line.regexpCapture(".*::set-output\\s+name=(.*)::.*", 1) or
        output = line.regexpCapture(".*echo\\s*\"(.*)=.*\\s*>>\\s*(\")?\\$GITHUB_OUTPUT.*", 1)
      ) and
      // TODO: repalce script with line below
      script.indexOf("$" + ["", "{", "ENV{"] + varName) > 0
    ) and
    succ.asExpr() = r
  )
}
