import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import DataFlow::PathGraph

/**
 * A taint-tracking configuration for unvalidated user input that is used in Unified EL evaluation.
 */
class UnifiedELInjectionFlowConfig extends TaintTracking::Configuration {
  UnifiedELInjectionFlowConfig() { this = "UnifiedELInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof ExpressionFactoryInjectionSink or sink instanceof ELProcessorInjectionSink
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    createMethodValueExpressionStep(node1, node2)
  }
}

/** The class `javax.el.MethodExpression`. */
class TypeMethodExpression extends Class {
  TypeMethodExpression() { this.hasQualifiedName("javax.el", "MethodExpression") }
}

/** The class `javax.el.ValueExpression`. */
class TypeValueExpression extends Class {
  TypeValueExpression() { this.hasQualifiedName("javax.el", "ValueExpression") }
}

/** The class `javax.el.ExpressionFactory`. */
class TypeExpressionFactory extends Class {
  TypeExpressionFactory() { this.hasQualifiedName("javax.el", "ExpressionFactory") }
}

/** The class `javax.el.ELProcessor`. */
class TypeELProcessor extends Class {
  TypeELProcessor() { this.hasQualifiedName("javax.el", "ELProcessor") }
}

/**
 * `ExpressionFactory` sink for Unified EL injection vulnerabilities, i.e.
 * `MethodExpression.invoke`, `ValueExpression.getValue` or `ValueExpression.setValue` method call.
 */
class ExpressionFactoryInjectionSink extends DataFlow::ExprNode {
  ExpressionFactoryInjectionSink() {
    exists(MethodAccess ma, Method m, Type t |
      ma.getMethod() = m and
      ma.getQualifier() = this.getExpr() and
      this.getExpr().getType() = t
    |
      t instanceof TypeMethodExpression and m.hasName("invoke")
      or
      t instanceof TypeValueExpression and
      (m.hasName("getValue") or m.hasName("setValue"))
    )
  }
}

/**
 * `ELProcessor` sink for Unified EL injection vulnerabilities, i.e. 1st argument to `eval`,
 * `getValue` or `setValue` method from `ELProcessor`.
 */
class ELProcessorInjectionSink extends DataFlow::ExprNode {
  ELProcessorInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      m.getDeclaringType() instanceof TypeELProcessor and
      (m.hasName("eval") or m.hasName("getValue") or m.hasName("setValue"))
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `MethodExpression`
 * or `ValueExpression`, i.e. `ExpressionFactory.createMethodExpression(tainted)` or
 * `ExpressionFactory.createValueExpression(tainted)`.
 */
predicate createMethodValueExpressionStep(ExprNode n1, ExprNode n2) {
  exists(MethodAccess ma, Method m |
    n1.asExpr() = ma.getArgument(1) and
    n2.asExpr() = ma and
    ma.getMethod() = m and
    m.getDeclaringType() instanceof TypeExpressionFactory
  |
    m.hasName("createMethodExpression") or m.hasName("createValueExpression")
  )
}
