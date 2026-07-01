private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow
import codeql.actions.security.ControlChecks
import codeql.actions.security.CachePoisoningQuery

class CodeInjectionSink extends DataFlow::Node {
  CodeInjectionSink() {
    exists(Run e | e.getAnScriptExpr() = this.asExpr()) or
    madSink(this, "code-injection")
  }
}

/**
 * Get the relevant event for the sink in CodeInjectionCritical.ql.
 */
Event getRelevantCriticalEventForSink(DataFlow::Node sink) {
  inPrivilegedContext(sink.asExpr(), result) and
  not exists(ControlCheck check | check.protects(sink.asExpr(), result, "code-injection")) and
  not isGithubScriptUsingToJson(sink.asExpr())
}

/**
 * Get the relevant event for the sink in CachePoisoningViaCodeInjection.ql.
 */
Event getRelevantCachePoisoningEventForSink(DataFlow::Node sink) {
  exists(LocalJob job |
    job = sink.asExpr().getEnclosingJob() and
    job.getATriggerEvent() = result and
    // job can be triggered by an external user
    result.isExternallyTriggerable() and
    // excluding privileged workflows since they can be exploited in easier circumstances
    // which is covered by `actions/code-injection/critical`
    not job.isPrivilegedExternallyTriggerable(result) and
    (
      // the workflow runs in the context of the default branch
      runsOnDefaultBranch(result)
      or
      // the workflow caller runs in the context of the default branch
      result.getName() = "workflow_call" and
      exists(ExternalJob caller |
        caller.getCallee() = job.getLocation().getFile().getRelativePath() and
        runsOnDefaultBranch(caller.getATriggerEvent())
      )
    )
  )
}

private predicate codeInjectionAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
  exists(Uses step |
    pred instanceof FileSource and
    pred.asExpr().(Step).getAFollowingStep() = step and
    succ.asExpr() = step and
    madSink(succ, "code-injection")
  )
  or
  exists(Run run |
    pred instanceof FileSource and
    pred.asExpr().(Step).getAFollowingStep() = run and
    succ.asExpr() = run.getScript() and
    exists(run.getScript().getAFileReadCommand())
  )
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a code script.
 */
private module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    codeInjectionAdditionalFlowStep(pred, succ)
  }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    result = getRelevantCriticalEventForSink(sink).getLocation()
    or
    result = getRelevantCachePoisoningEventForSink(sink).getLocation()
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;

private predicate knownSafeAction(string action) {
  action =
    [
      // Setup actions - version/cache outputs are deterministic
      "actions/setup-java",
      "actions/setup-python",
      "actions/setup-node",
      "actions/setup-go",
      "actions/setup-dotnet",
      "actions/cache",
      "actions/download-artifact",
      "actions/configure-pages",
      "actions/attest-build-provenance",
      "actions/create-github-app-token",
      "oracle-actions/setup-java",
      "spring-io/artifactory-deploy-action",
      "YunaBraska/java-info-action",
      // Docker actions - digest/version outputs are system-generated
      "docker/build-push-action",
      "docker/metadata-action",
      "docker/setup-buildx-action",
      // PR/repo automation - outputs are GitHub-assigned identifiers
      "dorny/test-reporter",
      "peter-evans/create-pull-request",
      // AWS actions - outputs are AWS-generated identifiers
      "aws-actions/aws-codebuild-run-build",
      // Security/crypto actions - outputs are cryptographic, not user-controllable
      "crazy-max/ghaction-import-gpg",
      // Hardware/system info actions - outputs are deterministic
      "SimonShi1994/cpu-cores"
    ]
}

/**
 * A taint-tracking configuration for step outputs
 * that are used to construct and evaluate a code script.
 */
private module CodeInjectionFromStepOutputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(StepOutputExpression soe, UsesStep us |
      soe = source.asExpr() and soe.getStepId() = us.getId()
    |
      not knownSafeAction(us.getCallee())
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    codeInjectionAdditionalFlowStep(pred, succ)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module CodeInjectionFromStepOutputFlow = TaintTracking::Global<CodeInjectionFromStepOutputConfig>;

/**
 * Holds if there is a code injection flow from `source` to `sink` with
 * critical severity, linked by `event`.
 */
predicate criticalSeverityCodeInjection(
  CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink, Event event
) {
  CodeInjectionFlow::flowPath(source, sink) and
  event = getRelevantCriticalEventForSink(sink.getNode()) and
  source.getNode().(RemoteFlowSource).getEventName() = event.getName()
}

/**
 * Holds if there is a code injection flow from `source` to `sink` with medium severity.
 */
predicate mediumSeverityCodeInjection(
  CodeInjectionFlow::PathNode source, CodeInjectionFlow::PathNode sink
) {
  CodeInjectionFlow::flowPath(source, sink) and
  not criticalSeverityCodeInjection(source, sink, _) and
  not isGithubScriptUsingToJson(sink.getNode().asExpr())
}

/**
 * Holds if there is a code injection flow from `source` to `sink` with low severity.
 */
predicate lowSeverityCodeInjection(
  CodeInjectionFromStepOutputFlow::PathNode source, CodeInjectionFromStepOutputFlow::PathNode sink
) {
  CodeInjectionFromStepOutputFlow::flowPath(source, sink) and
  not isGithubScriptUsingToJson(sink.getNode().asExpr())
}

/**
 * Holds if `expr` is the `script` input to `actions/github-script` and it uses
 * `toJson`.
 */
predicate isGithubScriptUsingToJson(Expression expr) {
  exists(UsesStep script |
    script.getCallee() = "actions/github-script" and
    script.getArgumentExpr("script") = expr and
    exists(getAToJsonReferenceExpression(expr.getExpression(), _))
  )
}
