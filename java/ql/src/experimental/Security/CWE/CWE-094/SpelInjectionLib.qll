import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import SpringFrameworkLib

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a SpEL expression.
 */
class ExpressionInjectionConfig extends TaintTracking::Configuration {
  ExpressionInjectionConfig() { this = "ExpressionInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or
    source instanceof WebRequestSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExpressionEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    expressionParsingStep(node1, node2) or
    springPropertiesStep(node1, node2)
  }
}

/**
 * A sink for SpEL injection vulnerabilities,
 * i.e. methods that run evaluation of a SpEL expression in a powerfull context.
 */
class ExpressionEvaluationSink extends DataFlow::ExprNode {
  ExpressionEvaluationSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m instanceof ExpressionEvaluationMethod and
      getExpr() = ma.getQualifier() and
      not exists(SafeEvaluationContextFlowConfig config |
        config.hasFlowTo(DataFlow::exprNode(ma.getArgument(0)))
      )
    )
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that parses a SpEL expression,
 * i.e. `parser.parseExpression(tainted)`.
 */
predicate expressionParsingStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType().getAnAncestor*() instanceof ExpressionParser and
    m.hasName("parseExpression") and
    ma.getAnArgument() = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * A configuration for safe evaluation context that may be used in expression evaluation.
 */
class SafeEvaluationContextFlowConfig extends DataFlow2::Configuration {
  SafeEvaluationContextFlowConfig() { this = "SpelInjection::SafeEvaluationContextFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SafeContextSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m instanceof ExpressionEvaluationMethod and
      ma.getArgument(0) = sink.asExpr()
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

class SafeContextSource extends DataFlow::ExprNode {
  SafeContextSource() {
    isSimpleEvaluationContextConstructorCall(getExpr()) or
    isSimpleEvaluationContextBuilderCall(getExpr())
  }
}

/**
 * Holds if `expr` constructs `SimpleEvaluationContext`.
 */
predicate isSimpleEvaluationContextConstructorCall(Expr expr) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof SimpleEvaluationContext and
    cc = expr
  )
}

/**
 * Holds if `expr` builds `SimpleEvaluationContext` via `SimpleEvaluationContext.Builder`,
 * e.g. `SimpleEvaluationContext.forReadWriteDataBinding().build()`.
 */
predicate isSimpleEvaluationContextBuilderCall(Expr expr) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType() instanceof SimpleEvaluationContextBuilder and
    m.hasName("build") and
    ma = expr
  )
}
