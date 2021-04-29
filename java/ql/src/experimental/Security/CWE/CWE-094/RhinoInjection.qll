import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/** The class `org.mozilla.javascript.Context`. */
class Context extends RefType {
  Context() { this.hasQualifiedName("org.mozilla.javascript", "Context") }
}

/**
 * A method that evaluates a Rhino expression.
 */
class EvaluateExpressionMethod extends Method {
  EvaluateExpressionMethod() {
    this.getDeclaringType().getAnAncestor*() instanceof Context and
    (
      hasName("evaluateString") or
      hasName("evaluateReader")
    )
  }
}

/**
 * A taint-tracking configuration for unsafe user input that is used to evaluate
 * a Rhino expression.
 */
class RhinoInjectionConfig extends TaintTracking::Configuration {
  RhinoInjectionConfig() { this = "RhinoInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof EvaluateExpressionSink }
}

/**
 * A sink for Rhino code injection vulnerabilities.
 */
class EvaluateExpressionSink extends DataFlow::ExprNode {
  EvaluateExpressionSink() {
    exists(MethodAccess ea, EvaluateExpressionMethod m | m = ea.getMethod() |
      this.asExpr() = ea.getArgument(1) and // The second argument is the JavaScript or Java input
      not exists(MethodAccess ca |
        (
          ca.getMethod().hasName("initSafeStandardObjects") // safe mode
          or
          ca.getMethod().hasName("setClassShutter") // `ClassShutter` constraint is enforced
        ) and
        ea.getQualifier() = ca.getQualifier().(VarAccess).getVariable().getAnAccess()
      )
    )
  }
}
