private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery

abstract class OutputClobberingSink extends DataFlow::Node { }

/**
 * Holds if a Run step declares a step output variable with contents from a local file.
 * e.g.
 *    run: |
 *      cat test-results/.vars >> $GITHUB_OUTPUT
 *      echo "sha=$(cat test-results/sha-number)" >> $GITHUB_OUTPUT
 *      echo "sha=$(<test-results/sha-number)" >> $GITHUB_OUTPUT
 */
class OutputClobberingFromFileReadSink extends OutputClobberingSink {
  OutputClobberingFromFileReadSink() {
    exists(Run run, Step step, string field1, string field2 |
      (
        step instanceof UntrustedArtifactDownloadStep
        or
        step instanceof SimplePRHeadCheckoutStep
      ) and
      step.getAFollowingStep() = run and
      this.asExpr() = run.getScript() and
      // A write to GITHUB_OUTPUT that is not attacker-controlled
      exists(string str |
        // The output of a command that is not a file read command
        run.getScript().getACmdReachingGitHubOutputWrite(str, field1) and
        not str = run.getScript().getAFileReadCommand()
        or
        // A hard-coded string
        run.getScript().getAWriteToGitHubOutput(field1, str) and
        str.regexpMatch("[\"'0-9a-zA-Z_\\-]+")
      ) and
      // A write to GITHUB_OUTPUT that is attacker-controlled
      (
        // echo "sha=$(<test-results/sha-number)" >> $GITHUB_OUTPUT
        exists(string cmd |
          run.getScript().getACmdReachingGitHubOutputWrite(cmd, field2) and
          run.getScript().getAFileReadCommand() = cmd
        )
        or
        // cat test-results/.vars >> $GITHUB_OUTPUT
        run.getScript().fileToGitHubOutput(_) and
        field2 = "UNKNOWN"
      )
    )
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it in a step variable output.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "FOO=$BODY" >> $GITHUB_OUTPUT
 */
class OutputClobberingFromEnvVarSink extends OutputClobberingSink {
  OutputClobberingFromEnvVarSink() {
    exists(Run run, string field1, string field2 |
      // A write to GITHUB_OUTPUT that is attacker-controlled
      exists(string var |
        run.getScript().getAnEnvReachingGitHubOutputWrite(var, field1) and
        exists(run.getInScopeEnvVarExpr(var)) and
        run.getScript() = this.asExpr()
      ) and
      // A write to GITHUB_OUTPUT that is not attacker-controlled
      exists(string str |
        // The output of a command that is not a file read command
        run.getScript().getACmdReachingGitHubOutputWrite(str, field2) and
        not str = run.getScript().getAFileReadCommand()
        or
        // A hard-coded string
        run.getScript().getAWriteToGitHubOutput(field2, str) and
        str.regexpMatch("[\"'0-9a-zA-Z_\\-]+")
      ) and
      not field2 = field1
    )
  }
}

/**
 *      - id: clob1
 *        env:
 *          BODY: ${{ github.event.comment.body }}
 *        run: |
 *          # VULNERABLE
 *          echo $BODY
 *          echo "::set-output name=OUTPUT::SAFE"
 *      - id: clob2
 *        env:
 *          BODY: ${{ github.event.comment.body }}
 *        run: |
 *          # VULNERABLE
 *          echo "::set-output name=OUTPUT::SAFE"
 *          echo $BODY
 */
class WorkflowCommandClobberingFromEnvVarSink extends OutputClobberingSink {
  string clobbering_var;
  string clobbered_value;

  WorkflowCommandClobberingFromEnvVarSink() {
    exists(Run run, string workflow_cmd_stmt, string clobbering_stmt |
      run.getScript() = this.asExpr() and
      run.getScript().getAStmt() = clobbering_stmt and
      clobbering_stmt.regexpMatch("echo\\s+(-e\\s+)?(\"|')?\\$(\\{)?" + clobbering_var + ".*") and
      exists(run.getInScopeEnvVarExpr(clobbering_var)) and
      run.getScript().getAStmt() = workflow_cmd_stmt and
      clobbered_value =
        trimQuotes(workflow_cmd_stmt.regexpCapture(".*::set-output\\s+name=.*::(.*)", 1))
    )
  }
}

/**
 *      - id: clob1
 *        run: |
 *          # VULNERABLE
 *          PR="$(<pr-number)"
 *          echo "$PR"
 *          echo "::set-output name=OUTPUT::SAFE"
 *      - id: clob2
 *        run: |
 *          # VULNERABLE
 *          cat pr-number
 *          echo "::set-output name=OUTPUT::SAFE"
 *      - id: clob3
 *        run: |
 *          # VULNERABLE
 *          echo "::set-output name=OUTPUT::SAFE"
 *          ls *.txt
 *      - id: clob4
 *        run: |
 *          # VULNERABLE
 *          CURRENT_VERSION=$(cat gradle.properties | sed -n '/^version=/ { s/^version=//;p }')
 *          echo "$CURRENT_VERSION"
 *          echo "::set-output name=OUTPUT::SAFE"
 */
class WorkflowCommandClobberingFromFileReadSink extends OutputClobberingSink {
  string clobbering_cmd;

  WorkflowCommandClobberingFromFileReadSink() {
    exists(Run run, string clobbering_stmt |
      run.getScript() = this.asExpr() and
      run.getScript().getAStmt() = clobbering_stmt and
      (
        // A file's content is assigned to an env var that gets printed to stdout
        // - run: |
        //     foo=$(<pr-id.txt)"
        //     echo "${foo}"
        exists(string var, string value |
          run.getScript().getAnAssignment(var, value) and
          clobbering_cmd = run.getScript().getAFileReadCommand() and
          trimQuotes(value) = ["$(" + clobbering_cmd + ")", "`" + clobbering_cmd + "`"] and
          clobbering_stmt.regexpMatch("echo.*\\$(\\{)?" + var + ".*")
        )
        or
        // A file is read and its content is printed to stdout
        clobbering_cmd = run.getScript().getACommand() and
        clobbering_cmd.regexpMatch(["ls", Bash::fileReadCommand()] + "\\s.*") and
        (
          // - run: echo "foo=$(<pr-id.txt)"
          clobbering_stmt.regexpMatch("echo.*" + clobbering_cmd + ".*")
          or
          // A file content is printed to stdout
          // - run: cat pr-id.txt
          clobbering_stmt.indexOf(clobbering_cmd) = 0
        )
      )
    )
  }
}

class OutputClobberingFromMaDSink extends OutputClobberingSink {
  OutputClobberingFromMaDSink() { madSink(this, "output-clobbering") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module OutputClobberingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not source.(RemoteFlowSource).getSourceType() = "branch"
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof OutputClobberingSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScript() and
      run.getScript().getAWriteToGitHubOutput(_, _)
    )
    or
    exists(Uses step |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = step and
      succ.asExpr() = step and
      madSink(succ, "output-clobbering")
    )
    or
    exists(Run run |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScript() and
      (
        exists(run.getScript().getAFileReadCommand()) or
        run.getScript().getAStmt().matches("%::set-output %")
      )
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module OutputClobberingFlow = TaintTracking::Global<OutputClobberingConfig>;
