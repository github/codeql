/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import actions
private import codeql.util.Unit
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.FlowSources
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.OutputClobberingQuery
private import codeql.actions.security.UntrustedCheckoutQuery

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
 * Holds if and environment variable is used, directly or indirectly, in a Run's step expression.
 * Where the expression is a string captured from the Run's script.
 */
bindingset[var_name, expr]
predicate envToRunExpr(string var_name, Run run, string expr) {
  // e.g. echo "FOO=$BODY" >> $GITHUB_ENV
  // e.g. echo "FOO=${BODY}" >> $GITHUB_ENV
  expr.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
  or
  // e.g. echo "FOO=$(echo $BODY)" >> $GITHUB_ENV
  expr.matches("$(echo %") and expr.indexOf(var_name) > 0
  or
  // e.g.
  // FOO=$(echo $BODY)
  // echo "FOO=$FOO" >> $GITHUB_ENV
  exists(string line, string var2_name, string var2_value | run.getScript().splitAt("\n") = line |
    var2_name = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 1) and
    var2_value = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 2) and
    var2_value.matches("%$" + ["", "{", "ENV{"] + var_name + "%") and
    (
      expr.matches("%$" + ["", "{", "ENV{"] + var2_name + "%")
      or
      expr.matches("$(echo %") and expr.indexOf(var2_name) > 0
    )
  )
}

/**
 * Holds if an environment variable is used, directly or indirectly, as an argument to a dangerous command
 * in a Run step.
 * Where the command is a string captured from the Run's script.
 */
bindingset[var_name]
predicate envToArgInjSink(string var_name, Run run, string command) {
  exists(string argument, string line, string regexp, int command_group, int argument_group |
    run.getScript().splitAt("\n") = line and
    argumentInjectionSinksDataModel(regexp, command_group, argument_group) and
    argument = line.regexpCapture(regexp, argument_group) and
    command = line.regexpCapture(regexp, command_group) and
    envToRunExpr(var_name, run, argument) and
    exists(run.getInScopeEnvVarExpr(var_name))
  )
}

/**
 * Holds if an env var is passed to a Run step and this Run step, writes its value to a special workflow file.
 *   - file is the name of the special workflow file: GITHUB_ENV, GITHUB_OUTPUT, GITHUB_PATH
 *   - var_name is the name of the env var
 *   - run is the Run step
 *   - key is the name assigned in the special workflow file.
 *     e.g. FOO for `echo "FOO=$BODY" >> $GITHUB_ENV`
 *     e.g. FOO for `echo "FOO=$(echo $BODY)" >> $GITHUB_OUTPUT`
 *     e.g. path (special name) for `echo "$BODY" >> $GITHUB_PATH`
 */
bindingset[var_name]
predicate envToSpecialFile(string file, string var_name, Run run, string key) {
  exists(string value |
    (
      file = "GITHUB_ENV" and
      run.getAWriteToGitHubEnv(key, value)
      or
      file = "GITHUB_OUTPUT" and
      run.getAWriteToGitHubOutput(key, value)
      or
      file = "GITHUB_PATH" and
      run.getAWriteToGitHubPath(value) and
      key = "path"
    ) and
    envToRunExpr(var_name, run, value)
  )
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
  exists(Run run, string var_name |
    run.getInScopeEnvVarExpr(var_name) = pred.asExpr() and
    succ.asExpr() = run.getScriptScalar() and
    (
      envToSpecialFile(["GITHUB_ENV", "GITHUB_OUTPUT", "GITHUB_PATH"], var_name, run, _) or
      envToArgInjSink(var_name, run, _) or
      exists(OutputClobberingSink n | n.asExpr() = run.getScriptScalar())
    )
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
  exists(Run run, string var_name, string key |
    run.getInScopeEnvVarExpr(var_name) = pred.asExpr() and
    succ.asExpr() = run and
    envToSpecialFile("GITHUB_OUTPUT", var_name, run, key) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key)
  )
}

predicate envToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string var_name, string key, string value |
    run.getAWriteToGitHubEnv(key, value) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getInScopeEnvVarExpr(var_name) and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob() and
    Bash::isBashParameterExpansion(value, var_name, _, _)
  )
}

predicate controlledCWD(Step artifact) {
  artifact instanceof UntrustedArtifactDownloadStep or
  // This shoould be:
  // artifact instanceof PRHeadCheckoutStep
  // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
  // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
  // instead of using  ActionsMutableRefCheckout and ActionsSHACheckout
  artifact.(Uses).getCallee() = "actions/checkout" or
  artifact instanceof GitMutableRefCheckout or
  artifact instanceof GitSHACheckout or
  artifact instanceof GhMutableRefCheckout or
  artifact instanceof GhSHACheckout
}

/**
 * A downloaded artifact that gets assigned to a Run step output.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-output name=id::$(<pr-id.txt)"
 * - run: |
 *    foo=$(<pr-id.txt)"
 *    echo "::set-output name=id::$foo
 */
predicate artifactToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, Step artifact, string key, string value |
    controlledCWD(artifact) and
    (
      // A file is read and its content is assigned to an env var
      // - run: |
      //     foo=$(<pr-id.txt)"
      //     echo "::set-output name=id::$foo
      exists(string var_name, string file_read |
        run.getAnAssignment(var_name, file_read) and
        Bash::outputsPartialFileContent(run, file_read) and
        envToRunExpr(var_name, run, value) and
        run.getAWriteToGitHubOutput(key, value)
      )
      or
      // A file is read and its content is assigned to an output
      // - run: echo "::set-output name=id::$(<pr-id.txt)"
      run.getAWriteToGitHubOutput(key, value) and
      Bash::outputsPartialFileContent(run, value)
    ) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    artifact.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    succ.asExpr() = run
  )
}

/**
 * A downloaded artifact that gets assigned to an environment variable.
 * - run: echo "foo=$(<pr-id.txt)" >> "$GITHUB_ENV"
 * - run: |
 *    foo=$(<pr-id.txt)"
 *    echo "bar=${foo}" >> "$GITHUB_ENV"
 */
predicate artifactToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(Run run, string key, string value, Step artifact |
    controlledCWD(artifact) and
    (
      // A file is read and its content is assigned to an env var
      // - run: |
      //     foo=$(<pr-id.txt)"
      //     echo "bar=${foo}" >> "$GITHUB_ENV"
      exists(string var_name, string file_read |
        run.getAnAssignment(var_name, file_read) and
        Bash::outputsPartialFileContent(run, file_read) and
        envToRunExpr(var_name, run, value) and
        run.getAWriteToGitHubEnv(key, value)
      )
      or
      // A file is read and its content is assigned to an output
      // - run: echo "foo=$(<pr-id.txt)" >> "$GITHUB_ENV"
      run.getAWriteToGitHubEnv(key, value) and
      Bash::outputsPartialFileContent(run, value)
    ) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    artifact.getAFollowingStep() = run and
    pred.asExpr() = run.getScriptScalar() and
    // we store the taint on the enclosing job since there may not be an implicit env attribute
    succ.asExpr() = run.getEnclosingJob()
  )
}

/**
 * A download artifact step followed by a step that may use downloaded artifacts.
 */
predicate artifactDownloadToRunStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Step artifact, Run run |
    controlledCWD(artifact) and
    pred.asExpr() = artifact and
    succ.asExpr() = run.getScriptScalar() and
    artifact.getAFollowingStep() = run
  )
}

//
/**
 * A download artifact step followed by a uses step .
 */
predicate artifactDownloadToUsesStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Step artifact, Uses uses |
    controlledCWD(artifact) and
    pred.asExpr() = artifact and
    succ.asExpr() = uses and
    artifact.getAFollowingStep() = uses
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
    pred instanceof TJActionsVerifyChangedFilesSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() = "changed_files" and
    succ.asExpr() = o
  )
}

/**
 * A read of user-controlled field of the xt0rted/slash-command-action action.
 */
predicate xt0rtedSlashCommandActionTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(StepsExpression o |
    pred instanceof Xt0rtedSlashCommandSource and
    o.getTarget() = pred.asExpr() and
    o.getStepId() = pred.asExpr().(UsesStep).getId() and
    o.getFieldName() = "command-arguments" and
    succ.asExpr() = o
  )
}

class TaintSteps extends AdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    envToRunStep(node1, node2) or
    artifactDownloadToRunStep(node1, node2) or
    artifactDownloadToUsesStep(node1, node2) or
    // 3rd party actions
    dornyPathsFilterTaintStep(node1, node2) or
    tjActionsChangedFilesTaintStep(node1, node2) or
    tjActionsVerifyChangedFilesTaintStep(node1, node2) or
    xt0rtedSlashCommandActionTaintStep(node1, node2)
  }
}
