/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery

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
 * Holds if a Run step declares an environment variable, uses it in its script and sets an output in its script.
 * e.g.
 *  - name: Extract and Clean Initial URL
 *    id: extract-url
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "::set-output name=foo::$BODY"
 *      echo "foo=$(echo $BODY)" >> $GITHUB_OUTPUT
 *      echo "foo=$(echo $BODY)" >> "$GITHUB_OUTPUT"
 */
predicate envToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string varName, string output |
    c = any(DataFlow::FieldContent ct | ct.getName() = output.replaceAll("output\\.", "")) and
    run.getInScopeEnvVarExpr(varName) = pred.asExpr() and
    exists(string script, string line |
      script = run.getScript() and
      line = script.splitAt("\n") and
      Utils::extractAssignment(line, "OUTPUT", output, _) and
      line.indexOf("$" + ["", "{", "ENV{"] + varName) > 0
    ) and
    succ.asExpr() = run
  )
}

/**
 * A downloaded artifact that gets assigned to a Run step output.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-output name=id::$(<pr-id.txt)"
 */
predicate artifactToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string key, string value, ArtifactDownloadStep download |
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    download.getAFollowingStep() = run and
    pred.asExpr() = download and
    succ.asExpr() = run and
    Utils::writeToGitHubOutput(run, key, value) and
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

/**
 * A downloaded artifact that gets assigned to an env var declaration.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-env name=id::$(<pr-id.txt)"
 */
predicate artifactToEnvStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Run run, string key, string value, ArtifactDownloadStep download |
    pred.asExpr() = download and
    succ.asExpr() = run and
    download.getAFollowingStep() = run and
    Utils::writeToGitHubEnv(run, key, value) and
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

class ArtifactDownloadToEnvTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    artifactToEnvStep(node1, node2)
  }
}
