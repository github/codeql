import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unvalidated user input that is used in OGNL EL evaluation.
 */
class OgnlInjectionFlowConfig extends TaintTracking::Configuration {
  OgnlInjectionFlowConfig() { this = "OgnlInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof OgnlInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    parseCompileExpressionStep(node1, node2)
  }
}

/** The class `org.apache.commons.ognl.Ognl` or `ognl.Ognl`. */
class TypeOgnl extends Class {
  TypeOgnl() {
    this.hasQualifiedName("org.apache.commons.ognl", "Ognl") or
    this.hasQualifiedName("ognl", "Ognl")
  }
}

/** The interface `org.apache.commons.ognl.Node` or `ognl.Node`. */
class TypeNode extends Interface {
  TypeNode() {
    this.hasQualifiedName("org.apache.commons.ognl", "Node") or
    this.hasQualifiedName("ognl", "Node")
  }
}

/** The class `com.opensymphony.xwork2.ognl.OgnlUtil`. */
class TypeOgnlUtil extends Class {
  TypeOgnlUtil() { this.hasQualifiedName("com.opensymphony.xwork2.ognl", "OgnlUtil") }
}

/**
 * OGNL sink for OGNL injection vulnerabilities, i.e. 1st argument to `getValue` or `setValue`
 * method from `Ognl` or `getValue` or `setValue` method from `Node`.
 */
predicate ognlSinkMethod(Method m, int index) {
  (
    m.getDeclaringType() instanceof TypeOgnl
    or
    m.getDeclaringType().getAnAncestor*() instanceof TypeNode
  ) and
  (
    m.hasName("getValue") or
    m.hasName("setValue")
  ) and
  index = 0
}

/**
 * Struts sink for OGNL injection vulnerabilities, i.e. 1st argument to `getValue`, `setValue` or
 * `callMethod` method from `OgnlUtil`.
 */
predicate strutsSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeOgnlUtil and
  (
    m.hasName("getValue") or
    m.hasName("setValue") or
    m.hasName("callMethod")
  ) and
  index = 0
}

/** Holds if parameter at index `index` in method `m` is OGNL injection sink. */
predicate ognlInjectionSinkMethod(Method m, int index) {
  ognlSinkMethod(m, index) or
  strutsSinkMethod(m, index)
}

/** A data flow sink for unvalidated user input that is used in OGNL EL evaluation. */
class OgnlInjectionSink extends DataFlow::ExprNode {
  OgnlInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      (ma.getArgument(index) = this.getExpr() or ma.getQualifier() = this.getExpr()) and
      ognlInjectionSinkMethod(m, index)
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `Object` or `Node`,
 * i.e. `Ognl.parseExpression(tainted)` or `Ognl.compileExpression(tainted)`.
 */
predicate parseCompileExpressionStep(ExprNode n1, ExprNode n2) {
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
