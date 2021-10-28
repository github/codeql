/** Provides taint tracking and dataflow configurations to be used in SpEL injection queries. */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.spring.SpringExpression
private import semmle.code.java.security.SpelInjection

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a SpEL expression.
 */
class SpelInjectionConfig extends TaintTracking::Configuration {
  SpelInjectionConfig() { this = "SpelInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SpelExpressionEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(SpelExpressionInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/** Default sink for SpEL injection vulnerabilities. */
private class DefaultSpelExpressionEvaluationSink extends SpelExpressionEvaluationSink {
  DefaultSpelExpressionEvaluationSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ExpressionEvaluationMethod and
      ma.getQualifier() = this.asExpr() and
      not exists(SafeEvaluationContextFlowConfig config |
        config.hasFlowTo(DataFlow::exprNode(ma.getArgument(0)))
      )
    )
  }
}

/**
 * A configuration for safe evaluation context that may be used in expression evaluation.
 */
private class SafeEvaluationContextFlowConfig extends DataFlow2::Configuration {
  SafeEvaluationContextFlowConfig() { this = "SpelInjection::SafeEvaluationContextFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SafeContextSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof ExpressionEvaluationMethod and
      ma.getArgument(0) = sink.asExpr()
    )
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A `ContextSource` that is safe from SpEL injection.
 */
private class SafeContextSource extends DataFlow::ExprNode {
  SafeContextSource() {
    isSimpleEvaluationContextConstructorCall(this.getExpr()) or
    isSimpleEvaluationContextBuilderCall(this.getExpr())
  }
}

/**
 * Holds if `expr` constructs `SimpleEvaluationContext`.
 */
private predicate isSimpleEvaluationContextConstructorCall(Expr expr) {
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof SimpleEvaluationContext and
    cc = expr
  )
}

/**
 * Holds if `expr` builds `SimpleEvaluationContext` via `SimpleEvaluationContext.Builder`,
 * for instance, `SimpleEvaluationContext.forReadWriteDataBinding().build()`.
 */
private predicate isSimpleEvaluationContextBuilderCall(Expr expr) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType() instanceof SimpleEvaluationContextBuilder and
    m.hasName("build") and
    ma = expr
  )
}
