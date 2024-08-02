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
        step instanceof PRHeadCheckoutStep
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
            exists(string line, string var_name, string var_value |
              run.getScript().splitAt("\n") = line
            |
              var_name = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 1) and
              var_value = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 2) and
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
