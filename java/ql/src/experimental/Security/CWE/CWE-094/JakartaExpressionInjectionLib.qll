import java
import InjectionLib
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a Java EE expression.
 */
class JavaEEExpressionInjectionConfig extends TaintTracking::Configuration {
  JavaEEExpressionInjectionConfig() { this = "JavaEEExpressionInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ExpressionEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(TaintPropagatingCall c).taintFlow(fromNode, toNode) or
    returnsDataFromBean(fromNode, toNode)
  }
}

/**
 * A sink for Expresssion Language injection vulnerabilities,
 * i.e. method calls that run evaluation of a Java EE expression.
 */
private class ExpressionEvaluationSink extends DataFlow::ExprNode {
  ExpressionEvaluationSink() {
    exists(MethodAccess ma, Method m, Expr taintFrom |
      ma.getMethod() = m and taintFrom = this.asExpr()
    |
      m.getDeclaringType() instanceof ValueExpression and
      m.hasName(["getValue", "setValue"]) and
      ma.getQualifier() = taintFrom
      or
      m.getDeclaringType() instanceof MethodExpression and
      m.hasName("invoke") and
      ma.getQualifier() = taintFrom
      or
      m.getDeclaringType() instanceof LambdaExpression and
      m.hasName("invoke") and
      ma.getQualifier() = taintFrom
      or
      m.getDeclaringType() instanceof ELProcessor and
      m.hasName(["eval", "getValue", "setValue"]) and
      ma.getArgument(0) = taintFrom
    )
  }
}

/**
 * Defines method calls that propagate tainted expressions.
 */
private class TaintPropagatingCall extends Call {
  Expr taintFromExpr;

  TaintPropagatingCall() {
    taintFromExpr = this.getArgument(1) and
    exists(Method m | this.(MethodAccess).getMethod() = m |
      m.getDeclaringType() instanceof ExpressionFactory and
      m.hasName(["createValueExpression", "createMethodExpression"]) and
      taintFromExpr.getType() instanceof TypeString
    )
    or
    exists(Constructor c | this.(ConstructorCall).getConstructor() = c |
      c.getDeclaringType() instanceof LambdaExpression and
      taintFromExpr.getType() instanceof ValueExpression
    )
  }

  /**
   * Holds if `fromNode` to `toNode` is a dataflow step that propagates
   * tainted data.
   */
  predicate taintFlow(DataFlow::Node fromNode, DataFlow::Node toNode) {
    fromNode.asExpr() = taintFromExpr and toNode.asExpr() = this
  }
}

private class ELProcessor extends RefType {
  ELProcessor() { hasQualifiedName("javax.el", "ELProcessor") }
}

private class ExpressionFactory extends RefType {
  ExpressionFactory() { hasQualifiedName("javax.el", "ExpressionFactory") }
}

private class ValueExpression extends RefType {
  ValueExpression() { hasQualifiedName("javax.el", "ValueExpression") }
}

private class MethodExpression extends RefType {
  MethodExpression() { hasQualifiedName("javax.el", "MethodExpression") }
}

private class LambdaExpression extends RefType {
  LambdaExpression() { hasQualifiedName("javax.el", "LambdaExpression") }
}
