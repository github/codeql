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
 * Holds if a Run step declares an environment variable with contents from a local file.
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
        step instanceof UntrustedArtifactDownloadStep or
        // This shoould be:
        // artifact instanceof PRHeadCheckoutStep
        // but PRHeadCheckoutStep uses Taint Tracking anc causes a non-Monolitic Recursion error
        // so we list all the subclasses of PRHeadCheckoutStep here and use actions/checkout as a workaround
        // instead of using  ActionsMutableRefCheckout and ActionsSHACheckout
        step.(Uses).getCallee() = "actions/checkout" or
        step instanceof GitMutableRefCheckout or
        step instanceof GitSHACheckout or
        step instanceof GhMutableRefCheckout or
        step instanceof GhSHACheckout
      ) and
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      (
        // e.g.
        // cat test-results/.vars >> $GITHUB_OUTPUT
        fileToGitHubOutput(run, _)
        or
        exists(string content, string key, string value |
          writeToGitHubOutput(run, content) and
          extractVariableAndValue(content, key, value) and
          // there is a different output variable in the same script
          // TODO: key2/value2 should be declared before key/value
          exists(string content2, string key2 |
            writeToGitHubOutput(run, content2) and
            extractVariableAndValue(content2, key2, _) and
            not key2 = key
          ) and
          (
            outputsPartialFileContent(value)
            or
            // e.g.
            // FOO=$(cat test-results/sha-number)
            // echo "FOO=$FOO" >> $GITHUB_OUTPUT
            exists(string var_name, string var_value |
              run.getAnAssignment(var_name, var_value) and
              outputsPartialFileContent(var_value) and
              (
                value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
                or
                value.regexpMatch("\\$\\((echo|printf|write-output)\\s+.*") and
                value.indexOf(var_name) > 0
              )
            )
          )
        )
      )
    )
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "FOO=$BODY" >> $GITHUB_OUTPUT
 */
class OutputClobberingFromEnvVarSink extends OutputClobberingSink {
  OutputClobberingFromEnvVarSink() {
    exists(Run run, string var_name, string key |
      envToSpecialFile("GITHUB_OUTPUT", var_name, run, key) and
      // there is a different output variable in the same script
      // TODO: key2/value2 should be declared before key/value
      exists(string content2, string key2 |
        writeToGitHubOutput(run, content2) and
        extractVariableAndValue(content2, key2, _) and
        not key2 = key
      ) and
      exists(run.getInScopeEnvVarExpr(var_name)) and
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
    exists(Run run, string output_line, string clobbering_line, string var_name |
      run.getScript().splitAt("\n") = output_line and
      singleLineWorkflowCmd(output_line, "set-output", _, _) and
      run.getScript().splitAt("\n") = clobbering_line and
      clobbering_line.regexpMatch(".*echo\\s+(-e\\s+)?(\"|')?\\$(\\{)?" + var_name + ".*") and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr()
    )
  }
}

class WorkflowCommandClobberingFromFileReadSink extends OutputClobberingSink {
  WorkflowCommandClobberingFromFileReadSink() {
    exists(Run run, string output_line, string clobbering_line |
      run.getScriptScalar() = this.asExpr() and
      run.getScript().splitAt("\n") = output_line and
      singleLineWorkflowCmd(output_line, "set-output", _, _) and
      run.getScript().splitAt("\n") = clobbering_line and
      (
        // A file is read and its content is assigned to an env var that gets printed to stdout
        // - run: |
        //     foo=$(<pr-id.txt)"
        //     echo "${foo}"
        exists(string var_name, string value, string assign_line, string assignment_regexp |
          run.getScript().splitAt("\n") = assign_line and
          assignment_regexp = "([a-zA-Z0-9\\-_]+)=(.*)" and
          var_name = assign_line.regexpCapture(assignment_regexp, 1) and
          value = assign_line.regexpCapture(assignment_regexp, 2) and
          outputsPartialFileContent(trimQuotes(value)) and
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
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module OutputClobberingFlow = TaintTracking::Global<OutputClobberingConfig>;
