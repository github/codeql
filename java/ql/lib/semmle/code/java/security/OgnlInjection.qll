/** Provides classes to reason about OGNL injection vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A data flow sink for unvalidated user input that is used in OGNL EL evaluation.
 *
 * Extend this class to add your own OGNL injection sinks.
 */
abstract class OgnlInjectionSink extends DataFlow::Node { }

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

private class DefaultOgnlInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.ognl;Ognl;false;getValue;;;Argument[0];ognl-injection",
        "org.apache.commons.ognl;Ognl;false;setValue;;;Argument[0];ognl-injection",
        "org.apache.commons.ognl;Node;true;getValue;;;Argument[-1];ognl-injection",
        "org.apache.commons.ognl;Node;true;setValue;;;Argument[-1];ognl-injection",
        "org.apache.commons.ognl.enhance;ExpressionAccessor;true;get;;;Argument[-1];ognl-injection",
        "org.apache.commons.ognl.enhance;ExpressionAccessor;true;set;;;Argument[-1];ognl-injection",
        "ognl;Ognl;false;getValue;;;Argument[0];ognl-injection",
        "ognl;Ognl;false;setValue;;;Argument[0];ognl-injection",
        "ognl;Node;false;getValue;;;Argument[-1];ognl-injection",
        "ognl;Node;false;setValue;;;Argument[-1];ognl-injection",
        "ognl.enhance;ExpressionAccessor;true;get;;;Argument[-1];ognl-injection",
        "ognl.enhance;ExpressionAccessor;true;set;;;Argument[-1];ognl-injection",
        "com.opensymphony.xwork2.ognl;OgnlUtil;false;getValue;;;Argument[0];ognl-injection",
        "com.opensymphony.xwork2.ognl;OgnlUtil;false;setValue;;;Argument[0];ognl-injection",
        "com.opensymphony.xwork2.ognl;OgnlUtil;false;callMethod;;;Argument[0];ognl-injection"
      ]
  }
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
  exists(MethodAccess ma, Method m, int index |
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
  exists(MethodAccess ma, Method m |
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
  exists(MethodAccess ma, Method m |
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
