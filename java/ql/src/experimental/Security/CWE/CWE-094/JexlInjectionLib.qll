import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a Jexl expression.
 * It supports both Jexl2 and Jexl3.
 */
class JexlInjectionConfig extends TaintTracking::Configuration {
  JexlInjectionConfig() { this = "JexlInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof TaintedSpringRequestBody or
    source instanceof RemoteFlowSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(TaintPropagatingJexlMethodCall c).taintFlow(fromNode, toNode) or
    returnsDataFromBean(fromNode, toNode)
  }
}

/**
 * A data flow source for parameters that have
 * a Spring framework annotation indicating remote user input from servlets.
 */
private class TaintedSpringRequestBody extends DataFlow::Node {
  TaintedSpringRequestBody() {
    exists(SpringServletInputAnnotation a | this.asParameter().getAnAnnotation() = a)
  }
}

/**
 * A sink for Expresssion Language injection vulnerabilities via Jexl,
 * i.e. method calls that run evaluation of a Jexl expression.
 */
private class JexlEvaluationSink extends DataFlow::ExprNode {
  JexlEvaluationSink() {
    exists(MethodAccess ma, Method m, Expr taintFrom |
      ma.getMethod() = m and taintFrom = this.asExpr()
    |
      m instanceof DirectJexlEvaluationMethod and ma.getQualifier() = taintFrom
      or
      m instanceof CallableCallMethod and ma.getQualifier() = taintFrom
      or
      m instanceof JexlEngineGetSetPropertyMethod and
      ma.getAnArgument().getType() instanceof TypeString and
      ma.getAnArgument() = taintFrom
    )
  }
}

/**
 * Defines method calls that propagate tainted data via one of the methods
 * from Jexl library.
 */
private class TaintPropagatingJexlMethodCall extends MethodAccess {
  Expr taintFromExpr;

  TaintPropagatingJexlMethodCall() {
    exists(Method m, RefType taintType |
      this.getMethod() = m and
      taintType = taintFromExpr.getType()
    |
      m instanceof CreateJexlScriptMethod and
      taintFromExpr = this.getArgument(0) and
      taintType instanceof TypeString
      or
      m instanceof CreateJexlCallableMethod and
      taintFromExpr = this.getQualifier()
      or
      m instanceof CreateJexlExpressionMethod and
      taintFromExpr = this.getAnArgument() and
      taintType instanceof TypeString
      or
      m instanceof CreateJexlTemplateMethod and
      (taintType instanceof TypeString or taintType instanceof Reader) and
      taintFromExpr = this.getArgument([0, 1])
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

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that returns data from
 * a tainted bean by calling one of its getters.
 */
private predicate returnsDataFromBean(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof GetterMethod and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * Method in the `JexlEngine` class that get or set a property with a Jexl expression.
 */
private class JexlEngineGetSetPropertyMethod extends Method {
  JexlEngineGetSetPropertyMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName(["getProperty", "setProperty"])
  }
}

/**
 * Defines methods that triggers direct evaluation of Jexl expressions.
 */
private class DirectJexlEvaluationMethod extends Method {
  DirectJexlEvaluationMethod() {
    getDeclaringType() instanceof JexlExpression and hasName("evaluate")
    or
    getDeclaringType() instanceof JexlScript and hasName("execute")
    or
    getDeclaringType() instanceof JxltEngineExpression and hasName(["evaluate", "prepare"])
    or
    getDeclaringType() instanceof JxltEngineTemplate and hasName("evaluate")
    or
    getDeclaringType() instanceof UnifiedJexlExpression and hasName(["evaluate", "prepare"])
    or
    getDeclaringType() instanceof UnifiedJexlTemplate and hasName("evaluate")
  }
}

/**
 * A method in the `Callable` class that executes the `Callable`.
 */
private class CallableCallMethod extends Method {
  CallableCallMethod() { getDeclaringType() instanceof CallableInterface and hasName("call") }
}

/**
 * Defines methods that create a Jexl script.
 */
private class CreateJexlScriptMethod extends Method {
  CreateJexlScriptMethod() { getDeclaringType() instanceof JexlEngine and hasName("createScript") }
}

/**
 * Defines methods that creates a `Callable` for a Jexl expression or script.
 */
private class CreateJexlCallableMethod extends Method {
  CreateJexlCallableMethod() {
    (getDeclaringType() instanceof JexlExpression or getDeclaringType() instanceof JexlScript) and
    hasName("callable")
  }
}

/**
 * Defines methods that create a Jexl template.
 */
private class CreateJexlTemplateMethod extends Method {
  CreateJexlTemplateMethod() {
    (getDeclaringType() instanceof JxltEngine or getDeclaringType() instanceof UnifiedJexl) and
    hasName("createTemplate")
  }
}

/**
 * Defines methods that create a Jexl expression.
 */
private class CreateJexlExpressionMethod extends Method {
  CreateJexlExpressionMethod() {
    (getDeclaringType() instanceof JexlEngine or getDeclaringType() instanceof JxltEngine) and
    hasName("createExpression")
    or
    getDeclaringType() instanceof UnifiedJexl and hasName("parse")
  }
}

private class JexlRefType extends RefType {
  JexlRefType() { getPackage().hasName(["org.apache.commons.jexl2", "org.apache.commons.jexl3"]) }
}

private class JexlExpression extends JexlRefType {
  JexlExpression() { hasName(["Expression", "JexlExpression"]) }
}

private class JexlScript extends JexlRefType {
  JexlScript() { hasName(["Script", "JexlScript"]) }
}

private class JexlEngine extends JexlRefType {
  JexlEngine() { hasName("JexlEngine") }
}

private class JxltEngine extends JexlRefType {
  JxltEngine() { hasName("JxltEngine") }
}

private class UnifiedJexl extends JexlRefType {
  UnifiedJexl() { hasName("UnifiedJEXL") }
}

private class JxltEngineExpression extends NestedType {
  JxltEngineExpression() { getEnclosingType() instanceof JxltEngine and hasName("Expression") }
}

private class JxltEngineTemplate extends NestedType {
  JxltEngineTemplate() { getEnclosingType() instanceof JxltEngine and hasName("Template") }
}

private class UnifiedJexlExpression extends NestedType {
  UnifiedJexlExpression() { getEnclosingType() instanceof UnifiedJexl and hasName("Expression") }
}

private class UnifiedJexlTemplate extends NestedType {
  UnifiedJexlTemplate() { getEnclosingType() instanceof UnifiedJexl and hasName("Template") }
}

private class CallableInterface extends RefType {
  CallableInterface() {
    getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName("java.util.concurrent", "Callable")
  }
}

private class Reader extends RefType {
  Reader() { hasQualifiedName("java.io", "Reader") }
}
