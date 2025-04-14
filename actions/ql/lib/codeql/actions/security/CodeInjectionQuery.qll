private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

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
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module CodeInjectionFlow = TaintTracking::Global<CodeInjectionConfig>;
