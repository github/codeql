/**
 * Provides classes representing various flow steps for taint tracking.
 */

private import actions
private import codeql.actions.DataFlow
private import codeql.actions.dataflow.FlowSources

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
  exists(Run run, string var, string field |
    run.getInScopeEnvVarExpr(var) = pred.asExpr() and
    succ.asExpr() = run and
    Bash::envReachingGitHubFileWrite(run, var, "GITHUB_OUTPUT", field) and
    c = any(DataFlow::FieldContent ct | ct.getName() = field)
  )
}

predicate envToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(
    Run run, string var, string field //string key, string value |
  |
    run.getInScopeEnvVarExpr(var) = pred.asExpr() and
    // we store the taint on the enclosing job since the may not exist an implicit env attribute
    succ.asExpr() = run.getEnclosingJob() and
    Bash::envReachingGitHubFileWrite(run, var, "GITHUB_ENV", field) and
    c = any(DataFlow::FieldContent ct | ct.getName() = field) //and
  )
}

/**
 * A command whose output gets assigned to an environment variable or step output.
 * - run: |
 *     echo "foo=$(cmd)" >> "$GITHUB_OUTPUT"
 * - run: |
 *    foo=$(<cmd)"
 *    echo "bar=${foo}" >> "$GITHUB_OUTPUT"
 */
predicate commandToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(CommandSource source, Run run, string key, string cmd |
    source.getCommand() = cmd and
    Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_OUTPUT", key) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getScriptScalar() and
    succ.asExpr() = run
  )
}

/**
 * A command whose output gets assigned to an environment variable or step output.
 * - run: |
 *     echo "foo=$(cmd)" >> "$GITHUB_ENV"
 * - run: |
 *    foo=$(<cmd)"
 *    echo "bar=${foo}" >> "$GITHUB_ENV"
 */
predicate commandToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(CommandSource source, Run run, string key, string cmd |
    source.getCommand() = cmd and
    Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_ENV", key) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getScriptScalar() and
    // we store the taint on the enclosing job since there may not be an implicit env attribute
    succ.asExpr() = run.getEnclosingJob()
  )
}

/**
 * A downloaded artifact that gets assigned to a Run step output.
 * - uses: actions/download-artifact@v2
 * - run: echo "::set-output name=id::$(<pr-id.txt)"
 * - run: |
 *    foo=$(<pr-id.txt)"
 *    echo "::set-output name=id::$foo
 */
predicate fileToOutputStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(FileSource source, Run run, string key, string cmd |
    source.asExpr().(Step).getAFollowingStep() = run and
    Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_OUTPUT", key) and
    Bash::outputsPartialFileContent(run, cmd) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
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
predicate fileToEnvStoreStep(DataFlow::Node pred, DataFlow::Node succ, DataFlow::ContentSet c) {
  exists(FileSource source, Run run, string key, string cmd |
    source.asExpr().(Step).getAFollowingStep() = run and
    Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_ENV", key) and
    Bash::outputsPartialFileContent(run, cmd) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getScriptScalar() and
    // we store the taint on the enclosing job since there may not be an implicit env attribute
    succ.asExpr() = run.getEnclosingJob()
  )
}
