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
 * Holds if a Run step declares an environment variable, uses it in its script to set another env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "foo=$(echo $BODY)" >> $GITHUB_ENV
 */
predicate envToRunStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Run run, string varName, string value |
    run.getInScopeEnvVarExpr(varName) = pred.asExpr() and
    (
      Utils::writeToGitHubEnv(run, _, value) or
      Utils::writeToGitHubOutput(run, _, value) or
      Utils::writeToGitHubPath(run, value)
    ) and
    value.matches("%$" + ["", "{", "ENV{"] + varName + "%") and
    succ.asExpr() = run.getScriptScalar()
  )
}

class EnvToRunTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) { envToRunStep(node1, node2) }
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
  exists(Run run, string varName, string key, string value |
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getInScopeEnvVarExpr(varName) and
    succ.asExpr() = run and
    Utils::writeToGitHubOutput(run, key, value) and
    value.matches("%$" + ["", "{", "ENV{"] + varName + "%")
  )
}

predicate envToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string varName, string key, string value |
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getInScopeEnvVarExpr(varName) and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob() and
    Utils::writeToGitHubEnv(run, key, value) and
    value.matches("%$" + ["", "{", "ENV{"] + varName + "%")
  )
}

/**
 * A downloaded artifact that gets assigned to a Run step output.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-output name=id::$(<pr-id.txt)"
 */
predicate artifactToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string key, string value, UntrustedArtifactDownloadStep download |
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    download.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    succ.asExpr() = run and
    Utils::writeToGitHubOutput(run, key, value) and
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

predicate artifactToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string key, string value, UntrustedArtifactDownloadStep download |
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    download.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob() and
    Utils::writeToGitHubEnv(run, key, value) and
    value.regexpMatch([".*\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\).*"])
  )
}

/**
 * A download artifact step followed by a step that may use downloaded artifacts.
 */
predicate artifactDownloadToUseStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(UntrustedArtifactDownloadStep download, Run run |
    pred.asExpr() = download and
    succ.asExpr() = run.getScriptScalar() and
    download.getAFollowingStep() = run
  )
}

class ArtifactDownloadToUseTaintStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    artifactDownloadToUseStep(node1, node2)
  }
}
