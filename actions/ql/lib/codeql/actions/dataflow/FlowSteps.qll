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
    run.getScript().getAnEnvReachingGitHubOutputWrite(var, field) and
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
    run.getScript().getAnEnvReachingGitHubEnvWrite(var, field) and
    c = any(DataFlow::FieldContent ct | ct.getName() = field)
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
  exists(Run run, string key, string cmd |
    (
      exists(CommandSource source | source.getCommand() = cmd)
      or
      exists(FileSource source |
        source.asExpr().(Step).getAFollowingStep() = run and
        run.getScript().getAFileReadCommand() = cmd
      )
    ) and
    run.getScript().getACmdReachingGitHubOutputWrite(cmd, key) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getScript() and
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
  exists(Run run, string key, string cmd |
    (
      exists(CommandSource source | source.getCommand() = cmd)
      or
      exists(FileSource source |
        source.asExpr().(Step).getAFollowingStep() = run and
        run.getScript().getAFileReadCommand() = cmd
      )
    ) and
    run.getScript().getACmdReachingGitHubEnvWrite(cmd, key) and
    c = any(DataFlow::FieldContent ct | ct.getName() = key) and
    pred.asExpr() = run.getScript() and
    // we store the taint on the enclosing job since there may not be an implicit env attribute
    succ.asExpr() = run.getEnclosingJob()
  )
}
