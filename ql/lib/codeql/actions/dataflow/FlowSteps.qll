/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.FlowSources
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
  exists(Run run, string var_name, string content, string value |
    run.getInScopeEnvVarExpr(var_name) = pred.asExpr() and
    succ.asExpr() = run.getScriptScalar()
  |
    (
      writeToGitHubEnv(run, content) or
      writeToGitHubOutput(run, content)
    ) and
    extractVariableAndValue(content, _, value) and
    value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
    or
    writeToGitHubPath(run, content) and
    value = content and
    value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
  )
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
 *      echo "::set-output name=step-output::$BODY"
 */
predicate envToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string var_name, string content, string key, string value |
    writeToGitHubOutput(run, content) and
    extractVariableAndValue(content, key, value) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getInScopeEnvVarExpr(var_name) and
    succ.asExpr() = run and
    value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
  )
}

predicate envToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string var_name, string content, string key, string value |
    writeToGitHubEnv(run, content) and
    extractVariableAndValue(content, key, value) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getInScopeEnvVarExpr(var_name) and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob() and
    isBashParameterExpansion(value, var_name, _, _)
  )
}

/**
 * A downloaded artifact that gets assigned to a Run step output.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-output name=id::$(<pr-id.txt)"
 */
predicate artifactToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string content, string key, string value, UntrustedArtifactDownloadStep download |
    writeToGitHubOutput(run, content) and
    extractVariableAndValue(content, key, value) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    download.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    succ.asExpr() = run and
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

predicate artifactToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string content, string key, string value, UntrustedArtifactDownloadStep download |
    writeToGitHubEnv(run, content) and
    extractVariableAndValue(content, key, value) and
    value.regexpMatch([".*\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\).*"]) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    download.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob()
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

/**
 * A read of the _files field of the dorny/paths-filter action.
 */
predicate dornyPathsFilterTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof DornyPathsFilterSource and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName().matches("%_files") and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the tj-actions/changed-files action.
 */
predicate tjActionsChangedFilesTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof TJActionsChangedFilesSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() =
      [
        "added_files", "copied_files", "deleted_files", "modified_files", "renamed_files",
        "all_old_new_renamed_files", "type_changed_files", "unmerged_files", "unknown_files",
        "all_changed_and_modified_files", "all_changed_files", "other_changed_files",
        "all_modified_files", "other_modified_files", "other_deleted_files", "modified_keys",
        "changed_keys"
      ] and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the tj-actions/verify-changed-files action.
 */
predicate tjActionsVerifyChangedFilesTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof TJActionsChangedFilesSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() = "changed_files" and
    succ.asExpr() = o
  )
}

class TaintSteps extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    envToRunStep(node1, node2) or
    artifactDownloadToUseStep(node1, node2) or
    dornyPathsFilterTaintStep(node1, node2) or
    tjActionsChangedFilesTaintStep(node1, node2) or
    tjActionsVerifyChangedFilesTaintStep(node1, node2)
  }
}
