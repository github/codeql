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
module SpelInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof SpelExpressionEvaluationSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(SpelExpressionInjectionAdditionalTaintStep c).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a SpEL expression. */
module SpelInjectionFlow = TaintTracking::Global<SpelInjectionConfig>;

/** Default sink for SpEL injection vulnerabilities. */
private class DefaultSpelExpressionEvaluationSink extends SpelExpressionEvaluationSink {
  DefaultSpelExpressionEvaluationSink() {
    exists(MethodCall ma |
      ma.getMethod() instanceof ExpressionEvaluationMethod and
      ma.getQualifier() = this.asExpr() and
      not SafeEvaluationContextFlow::flowToExpr(ma.getArgument(0))
    )
  }
}

/**
 * A configuration for safe evaluation context that may be used in expression evaluation.
 */
private module SafeEvaluationContextFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SafeContextSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall ma |
      ma.getMethod() instanceof ExpressionEvaluationMethod and
      ma.getArgument(0) = sink.asExpr()
    )
  }

  int fieldFlowBranchLimit() { result = 0 }
}

private module SafeEvaluationContextFlow = DataFlow::Global<SafeEvaluationContextFlowConfig>;

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
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    m.getDeclaringType() instanceof SimpleEvaluationContextBuilder and
    m.hasName("build") and
    ma = expr
  )
}
