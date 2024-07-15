private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.CodeInjectionQuery
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

abstract class OutputClobberingSource extends Step { }

class RunOutputClobbering extends OutputClobberingSource, Run {
  RunOutputClobbering() {
    exists(UntrustedArtifactDownloadStep download, string script |
      download.getAFollowingStep() = this and
      this.getScript() = script and
      exists(int i |
        script.splitAt("\n", i).matches(["%GITHUB_OUTPUT%", "%::set-output name%"]) and
        i < count(string line | line = script.splitAt("\n") | line) - 1
      )
    )
  }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a code script.
 */
private module OutputClobberingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof OutputClobberingSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CodeInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node prev, DataFlow::Node succ) {
    exists(StepsExpression e |
      e.getTarget() = prev.asExpr() and
      prev.asExpr() instanceof OutputClobberingSource and
      succ.asExpr() = e
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module OutputClobberingFlow = TaintTracking::Global<OutputClobberingConfig>;
