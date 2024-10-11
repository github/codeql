private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery
private import codeql.actions.dataflow.FlowSteps
import codeql.actions.DataFlow
import codeql.actions.dataflow.FlowSources

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
    exists(Run run, Step step |
      (
        step instanceof UntrustedArtifactDownloadStep
        or
        // This shoould be:
        // artifact instanceof PRHeadCheckoutStep
        // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
        // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
        // instead of using  ActionsMutableRefCheckout and ActionsSHACheckout
        exists(Uses uses |
          step = uses and
          uses.getCallee() = "actions/checkout" and
          exists(uses.getArgument("ref"))
        )
        or
        step instanceof GitMutableRefCheckout
        or
        step instanceof GitSHACheckout
        or
        step instanceof GhMutableRefCheckout
        or
        step instanceof GhSHACheckout
      ) and
      step.getAFollowingStep() = run and
      this.asExpr() = run.getScriptScalar() and
      (
        exists(string cmd |
          Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_OUTPUT", _) and
          Bash::outputsPartialFileContent(run, cmd)
        )
        or
        Bash::fileToGitHubOutput(run, _)
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
    exists(Run run, string var, string field |
      Bash::envReachingGitHubFileWrite(run, var, "GITHUB_OUTPUT", field) and
      // there is a different output variable in the same script
      // TODO: key2/value2 should be declared before key/value
      exists(string field2 |
        run.getAWriteToGitHubOutput(field2, _) and
        not field2 = field
      ) and
      exists(run.getInScopeEnvVarExpr(var)) and
      run.getScriptScalar() = this.asExpr()
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
  WorkflowCommandClobberingFromEnvVarSink() {
    exists(Run run, string clobbering_line, string var_name |
      Bash::singleLineWorkflowCmd(run.getACommand(), "set-output", _, _) and
      run.getACommand() = clobbering_line and
      clobbering_line.regexpMatch(".*echo\\s+(-e\\s+)?(\"|')?\\$(\\{)?" + var_name + ".*") and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr()
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
  WorkflowCommandClobberingFromFileReadSink() {
    exists(Run run, string clobbering_line |
      run.getScriptScalar() = this.asExpr() and
      Bash::singleLineWorkflowCmd(run.getACommand(), "set-output", _, _) and
      run.getACommand() = clobbering_line and
      (
        // A file is read and its content is assigned to an env var that gets printed to stdout
        // - run: |
        //     foo=$(<pr-id.txt)"
        //     echo "${foo}"
        exists(string var_name, string value |
          run.getAnAssignment(var_name, value) and
          Bash::outputsPartialFileContent(run, trimQuotes(value)) and
          clobbering_line.regexpMatch(".*echo\\s+(-e\\s+)?(\"|')?\\$(\\{)?" + var_name + ".*")
        )
        or
        // A file is read and its content is printed to stdout
        // - run: echo "foo=$(<pr-id.txt)"
        clobbering_line.regexpMatch(".*echo\\s+(-e)?\\s*(\"|')?") and
        clobbering_line.regexpMatch(["ls", Bash::partialFileContentCommand()] + "\\s.*")
        or
        // A file content is printed to stdout
        // - run: cat pr-id.txt
        clobbering_line.regexpMatch(["ls", Bash::partialFileContentCommand()] + "\\s.*")
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
      succ.asExpr() = run.getScriptScalar() and
      run.getAWriteToGitHubOutput(_, _)
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
      succ.asExpr() = run.getScriptScalar() and
      (
        Bash::outputsPartialFileContent(run, run.getACommand()) or
        Bash::singleLineWorkflowCmd(run.getACommand(), "set-output", _, _)
      )
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module OutputClobberingFlow = TaintTracking::Global<OutputClobberingConfig>;
