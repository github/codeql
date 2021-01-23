import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a Jexl expression.
 * It supports both Jexl2 and Jexl3.
 */
class JexlInjectionConfig extends TaintTracking::Configuration {
  TaintPropagatingJexlMethodCall taintPropagatingJexlMethodCall;

  JexlInjectionConfig() { this = "JexlInjectionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof TaintedSpringRequestBody or
    source instanceof RemoteFlowSource or
    source instanceof LocalUserInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    taintPropagatingJexlMethodCall.taintFlow(fromNode, toNode) or
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
    exists(MethodAccess ma, Method m, Expr tainted | ma.getMethod() = m and tainted = asExpr() |
      m instanceof DirectJexlEvaluationMethod and ma.getQualifier() = tainted
      or
      m instanceof CallableCallMethod and ma.getQualifier() = tainted
      or
      m instanceof JexlEngineGetSetPropertyMethod and
      ma.getAnArgument().getType() instanceof TypeString and
      ma.getAnArgument() = tainted
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
abstract private class DirectJexlEvaluationMethod extends Method { }

/**
 * A method in the `JexlExpression` class that evaluates a Jexl expression.
 */
private class JexlExpressionEvaluateMethod extends DirectJexlEvaluationMethod {
  JexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof JexlExpression and hasName("evaluate")
  }
}

/**
 * A method in the `JexlScript` class that executes a Jexl script.
 */
private class JexlScriptExecuteMethod extends DirectJexlEvaluationMethod {
  JexlScriptExecuteMethod() { getDeclaringType() instanceof JexlScript and hasName("execute") }
}

/**
 * A method in the `JxltEngine.Expression` class that evaluates an expression.
 */
private class JxltEngineExpressionEvaluateMethod extends DirectJexlEvaluationMethod {
  JxltEngineExpressionEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineExpression and hasName("evaluate")
  }
}

/**
 * A method in the `JxltEngine.Expression` class that evaluates the immediate sub-expressions.
 */
private class JxltEngineExpressionPrepareMethod extends DirectJexlEvaluationMethod {
  JxltEngineExpressionPrepareMethod() {
    getDeclaringType() instanceof JxltEngineExpression and hasName("prepare")
  }
}

/**
 * A method in the `JxltEngine.Template` class that evaluates a template.
 */
private class JxltEngineTemplateEvaluateMethod extends DirectJexlEvaluationMethod {
  JxltEngineTemplateEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineTemplate and hasName("evaluate")
  }
}

/**
 * A method in the `UnifiedJEXL.Expression` class that evaluates a template.
 */
private class UnifiedJexlExpressionEvaluateMethod extends DirectJexlEvaluationMethod {
  UnifiedJexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and hasName("evaluate")
  }
}

/**
 * A method in the `UnifiedJEXL.Expression` class that evaluates the immediate sub-expressions.
 */
private class UnifiedJexlExpressionPrepareMethod extends DirectJexlEvaluationMethod {
  UnifiedJexlExpressionPrepareMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and hasName("prepare")
  }
}

/**
 * A method in the `UnifiedJEXL.Template` class that evaluates a template.
 */
private class UnifiedJexlTemplateEvaluateMethod extends DirectJexlEvaluationMethod {
  UnifiedJexlTemplateEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlTemplate and hasName("evaluate")
  }
}

/**
 * A method in the `Callable` class that executes the `Callable`.
 */
private class CallableCallMethod extends Method {
  CallableCallMethod() { getDeclaringType() instanceof CallableInterface and hasName("call") }
}

private class CreateJexlScriptMethod extends Method {
  CreateJexlScriptMethod() { getDeclaringType() instanceof JexlEngine and hasName("createScript") }
}

private class CreateJexlCallableMethod extends Method {
  CreateJexlCallableMethod() {
    (getDeclaringType() instanceof JexlExpression or getDeclaringType() instanceof JexlScript) and
    hasName("callable")
  }
}

private class CreateJexlTemplateMethod extends Method {
  CreateJexlTemplateMethod() {
    (getDeclaringType() instanceof JxltEngine or getDeclaringType() instanceof UnifiedJexl) and
    hasName("createTemplate")
  }
}

private class CreateJexlExpressionMethod extends Method {
  CreateJexlExpressionMethod() {
    (getDeclaringType() instanceof JexlEngine or getDeclaringType() instanceof JxltEngine) and
    hasName("createExpression")
    or
    getDeclaringType() instanceof UnifiedJexl and hasName("parse")
  }
}

private class JexlExpression extends RefType {
  JexlExpression() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlExpression") or
    hasQualifiedName("org.apache.commons.jexl2", "Expression")
  }
}

private class JexlScript extends RefType {
  JexlScript() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlScript") or
    hasQualifiedName("org.apache.commons.jexl2", "Script")
  }
}

private class JexlEngine extends RefType {
  JexlEngine() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlEngine") or
    hasQualifiedName("org.apache.commons.jexl2", "JexlEngine")
  }
}

private class JxltEngine extends RefType {
  JxltEngine() { hasQualifiedName("org.apache.commons.jexl3", "JxltEngine") }
}

private class UnifiedJexl extends RefType {
  UnifiedJexl() { hasQualifiedName("org.apache.commons.jexl2", "UnifiedJEXL") }
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
