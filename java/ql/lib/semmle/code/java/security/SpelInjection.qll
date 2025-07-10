/** Provides classes to reason about SpEL injection attacks. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.frameworks.spring.SpringExpression

/** A data flow sink for unvalidated user input that is used to construct SpEL expressions. */
abstract class SpelExpressionEvaluationSink extends ApiSinkNode, DataFlow::ExprNode { }

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
private class DefaultSpelExpressionInjectionAdditionalTaintStep extends SpelExpressionInjectionAdditionalTaintStep
{
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    expressionParsingStep(node1, node2)
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that parses a SpEL expression,
 * by calling `parser.parseExpression(tainted)`.
 */
private predicate expressionParsingStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodCall ma, Method m | ma.getMethod() = m |
    m.getDeclaringType().getAnAncestor() instanceof ExpressionParser and
    m.hasName(["parseExpression", "parseRaw"]) and
    ma.getAnArgument() = node1.asExpr() and
    node2.asExpr() = ma
  )
}
