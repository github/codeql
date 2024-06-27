/** Provides classes to reason about OGNL injection vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.frameworks.MyBatis

/**
 * A data flow sink for unvalidated user input that is used in OGNL EL evaluation.
 *
 * Extend this class to add your own OGNL injection sinks.
 */
abstract class OgnlInjectionSink extends ApiSinkNode { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `OgnlInjectionFlowConfig`.
 */
class OgnlInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for OGNL injection taint configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultOgnlInjectionSink extends OgnlInjectionSink {
  DefaultOgnlInjectionSink() { sinkNode(this, "ognl-injection") }
}

/** The class `org.apache.commons.ognl.Ognl` or `ognl.Ognl`. */
private class TypeOgnl extends Class {
  TypeOgnl() { this.hasQualifiedName(["org.apache.commons.ognl", "ognl"], "Ognl") }
}

/** The interface `org.apache.commons.ognl.Node` or `ognl.Node`. */
private class TypeNode extends Interface {
  TypeNode() { this.hasQualifiedName(["org.apache.commons.ognl", "ognl"], "Node") }
}

/** The interface `org.apache.commons.ognl.enhance.ExpressionAccessor` or `ognl.enhance.ExpressionAccessor`. */
private class TypeExpressionAccessor extends Interface {
  TypeExpressionAccessor() {
    this.hasQualifiedName(["org.apache.commons.ognl.enhance", "ognl.enhance"], "ExpressionAccessor")
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `Object` or `Node`,
 * i.e. `Ognl.parseExpression(tainted)` or `Ognl.compileExpression(tainted)`.
 */
private predicate parseCompileExpressionStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m, int index |
    n1.asExpr() = ma.getArgument(index) and
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeOgnl
  |
    m.hasName("parseExpression") and index = 0
    or
    m.hasName("compileExpression") and index = 2
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Node` and `Accessor`,
 * i.e. `Node.getAccessor()`.
 */
private predicate getAccessorStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m |
    ma.getMethod() = m and
    m.getDeclaringType().getAnAncestor() instanceof TypeNode and
    m.hasName("getAccessor")
  |
    n1.asExpr() = ma.getQualifier() and
    n2.asExpr() = ma
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `Node` and `Accessor`
 * in a `setExpression` call, i.e. `accessor.setExpression(tainted)`
 */
private predicate setExpressionStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodCall ma, Method m |
    ma.getMethod() = m and
    m.hasName("setExpression") and
    m.getDeclaringType().getAnAncestor() instanceof TypeExpressionAccessor
  |
    n1.asExpr() = ma.getArgument(0) and
    n2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getQualifier()
  )
}

private class DefaultOgnlInjectionAdditionalTaintStep extends OgnlInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    parseCompileExpressionStep(node1, node2) or
    getAccessorStep(node1, node2) or
    setExpressionStep(node1, node2)
  }
}

private class MyBatisOgnlInjectionSink extends OgnlInjectionSink instanceof MyBatisInjectionSink { }
