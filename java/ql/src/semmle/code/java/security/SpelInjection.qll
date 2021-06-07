/** Provides classes to reason about SpEL injection attacks. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.FlowSources

/** A data flow sink for unvalidated user input that is used to construct SpEL expressions. */
abstract class SpelExpressionEvaluationSink extends DataFlow::ExprNode { }

private class SpelExpressionEvaluationModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.springframework.expression;Expression;true;getValue;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;getValueTypeDescriptor;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;getValueType;;;Argument[-1];spel",
        "org.springframework.expression;Expression;true;setValue;;;Argument[-1];spel"
      ]
  }
}

/** Default sink for SpEL injection vulnerabilities. */
private class DefaultSpelExpressionEvaluationSink extends SpelExpressionEvaluationSink {
  DefaultSpelExpressionEvaluationSink() {
    exists(MethodAccess ma |
      sinkNode(this, "spel") and
      this.asExpr() = ma.getQualifier() and
      not exists(SafeEvaluationContextFlowConfig config |
        config.hasFlowTo(DataFlow::exprNode(ma.getArgument(0)))
      )
    )
  }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `SpELInjectionConfig`.
 */
class SpelExpressionInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `SpELInjectionConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A set of additional taint steps to consider when taint tracking SpEL related data flows. */
private class DefaultSpelExpressionInjectionAdditionalTaintStep extends SpelExpressionInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    expressionParsingStep(node1, node2)
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

private class SafeContextSource extends DataFlow::ExprNode {
  SafeContextSource() {
    isSimpleEvaluationContextConstructorCall(getExpr()) or
    isSimpleEvaluationContextBuilderCall(getExpr())
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

/**
 * Methods that trigger evaluation of an expression.
 */
private class ExpressionEvaluationMethod extends Method {
  ExpressionEvaluationMethod() {
    this.getDeclaringType() instanceof Expression and
    this.hasName(["getValue", "getValueTypeDescriptor", "getValueType", "setValue"])
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that parses a SpEL expression,
 * by calling `parser.parseExpression(tainted)`.
 */
private predicate expressionParsingStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m.getDeclaringType().getAnAncestor*() instanceof ExpressionParser and
    m.hasName("parseExpression") and
    ma.getAnArgument() = node1.asExpr() and
    node2.asExpr() = ma
  )
}

private class SimpleEvaluationContext extends RefType {
  SimpleEvaluationContext() {
    hasQualifiedName("org.springframework.expression.spel.support", "SimpleEvaluationContext")
  }
}

private class SimpleEvaluationContextBuilder extends RefType {
  SimpleEvaluationContextBuilder() {
    hasQualifiedName("org.springframework.expression.spel.support",
      "SimpleEvaluationContext$Builder")
  }
}

private class Expression extends RefType {
  Expression() { hasQualifiedName("org.springframework.expression", "Expression") }
}

private class ExpressionParser extends RefType {
  ExpressionParser() { hasQualifiedName("org.springframework.expression", "ExpressionParser") }
}
