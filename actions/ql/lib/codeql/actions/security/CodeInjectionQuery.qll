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
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a code script.
 */
private module CodeInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
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

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) { none() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    // where clause from CodeInjectionCritical.ql
    exists(Event event, RemoteFlowSource source | result = event.getLocation() |
      inPrivilegedContext(sink.asExpr(), event) and
      isSource(source) and
      source.getEventName() = event.getName() and
      not exists(ControlCheck check | check.protects(sink.asExpr(), event, "code-injection")) and
      // exclude cases where the sink is a JS script and the expression uses toJson
      not exists(UsesStep script |
        script.getCallee() = "actions/github-script" and
        script.getArgumentExpr("script") = sink.asExpr() and
        exists(getAToJsonReferenceExpression(sink.asExpr().(Expression).getExpression(), _))
      )
    )
    or
    // where clause from CachePoisoningViaCodeInjection.ql
    exists(Event event, LocalJob job, DataFlow::Node source | result = event.getLocation() |
      job = sink.asExpr().getEnclosingJob() and
      job.getATriggerEvent() = event and
      // job can be triggered by an external user
      event.isExternallyTriggerable() and
      // the checkout is not controlled by an access check
      isSource(source) and
      not exists(ControlCheck check | check.protects(source.asExpr(), event, "code-injection")) and
      // excluding privileged workflows since they can be exploited in easier circumstances
      // which is covered by `actions/code-injection/critical`
      not job.isPrivilegedExternallyTriggerable(event) and
      (
        // the workflow runs in the context of the default branch
        runsOnDefaultBranch(event)
        or
        // the workflow caller runs in the context of the default branch
        event.getName() = "workflow_call" and
        exists(ExternalJob caller |
          caller.getCallee() = job.getLocation().getFile().getRelativePath() and
          runsOnDefaultBranch(caller.getATriggerEvent())
        )
      )
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;
