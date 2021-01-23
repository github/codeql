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
 * i.e. methods that run evaluation of a Jexl expression.
 */
private class JexlEvaluationSink extends DataFlow::ExprNode {
  JexlEvaluationSink() {
    isJexlExpressionEvaluationCall(asExpr()) or
    isJexlTemplateEvaluationCall(asExpr()) or
    isJexlScriptExecuteCall(asExpr()) or
    isJexlGetSetPropertyCall(asExpr()) or
    isCallableCall(asExpr())
  }
}

/**
 * Defines method calls that propagate tainted data via one of the methods
 * from Jexl library.
 */
private class TaintPropagatingJexlMethodCall extends MethodAccess {
  string methodName;
  RefType instanceType;
  Expr taintFromExpr;

  TaintPropagatingJexlMethodCall() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType() = instanceType and
      m.hasName(methodName)
    |
      isMethodForCreatingJexlScript(instanceType, methodName) and
      taintFromExpr = this.getArgument(0) and
      taintFromExpr.getType() instanceof TypeString
      or
      isMethodForCreatingJexlCallable(instanceType, methodName) and
      taintFromExpr = this.getQualifier()
      or
      isMethodForCreatingJexlExpression(instanceType, methodName) and
      taintFromExpr = this.getAnArgument() and
      taintFromExpr.getType() instanceof TypeString
      or
      isMethodForCreatingJexlTemplate(instanceType, methodName) and
      (taintFromExpr.getType() instanceof TypeString or taintFromExpr.getType() instanceof Reader) and
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
 * Checks if `instanceType.methodName()` method creates a Jexl script.
 */
private predicate isMethodForCreatingJexlScript(RefType instanceType, string methodName) {
  instanceType instanceof JexlEngine and methodName = "createScript"
}

/**
 * Checks if `instanceType.methodName()` method creates a `Callable` for a Jexl expression or script.
 */
private predicate isMethodForCreatingJexlCallable(RefType instanceType, string methodName) {
  (instanceType instanceof JexlExpression or instanceType instanceof JexlScript) and
  methodName = "callable"
}

/**
 * Checks if `instanceType.methodName()` method creates a Jexl template.
 */
private predicate isMethodForCreatingJexlTemplate(RefType instanceType, string methodName) {
  (instanceType instanceof JxltEngine or instanceType instanceof UnifiedJexl) and
  methodName = "createTemplate"
}

/**
 * Checks if `instanceType.methodName()` method creates a Jexl expression.
 */
private predicate isMethodForCreatingJexlExpression(RefType instanceType, string methodName) {
  (instanceType instanceof JexlEngine or instanceType instanceof JxltEngine) and
  methodName = "createExpression"
  or
  instanceType instanceof UnifiedJexl and methodName = "parse"
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
 * Holds if `expr` calls one of the methods that execute a Jexl script against qualifier `expr`.
 */
private predicate isJexlScriptExecuteCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m instanceof JexlScriptExecuteMethod and
    ma.getQualifier() = expr
  )
}

/**
 * Holds if `expr` is the qualifier when calling the `Callable.call()` method
 * such as `expr.call()`.
 */
private predicate isCallableCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m instanceof CallableCallMethod and
    ma.getQualifier() = expr
  )
}

/**
 * Holds if `expr` is an argument in a call to one of the methods
 * that get or set a property via a Jexl expression.
 */
private predicate isJexlGetSetPropertyCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (m instanceof JexlEngineGetPropertyMethod or m instanceof JexlEngineSetPropertyMethod) and
    ma.getAnArgument().getType() instanceof TypeString and
    ma.getAnArgument() = expr
  )
}

/**
 * Holds if `expr` is a call to one of the methods that trigger evaluation of a Jexl expression.
 */
private predicate isJexlExpressionEvaluationCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (
      m instanceof JexlExpressionEvaluateMethod or
      m instanceof JxltEngineExpressionEvaluateMethod or
      m instanceof JxltEngineExpressionPrepareMethod or
      m instanceof UnifiedJexlExpressionEvaluateMethod or
      m instanceof UnifiedJexlExpressionPrepareMethod
    ) and
    ma.getQualifier() = expr
  )
}

/**
 * Holds if `expr` is a call to one of the methods that evaluates a Jexl template.
 */
private predicate isJexlTemplateEvaluationCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (
      m instanceof JxltEngineTemplateEvaluateMethod or
      m instanceof UnifiedJexlTemplateEvaluateMethod
    ) and
    ma.getQualifier() = expr
  )
}

/**
 * A method in the `JexlExpression` class that evaluates a Jexl expression.
 */
private class JexlExpressionEvaluateMethod extends Method {
  JexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof JexlExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the `JexlEngine` class that gets a property with a Jexl expression.
 */
private class JexlEngineGetPropertyMethod extends Method {
  JexlEngineGetPropertyMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("getProperty")
  }
}

/**
 * A method in the `JexlEngine` class that sets a property with a Jexl expression.
 */
private class JexlEngineSetPropertyMethod extends Method {
  JexlEngineSetPropertyMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("setProperty")
  }
}

/**
 * A method in the `JexlScript` class that executes a Jexl script.
 */
private class JexlScriptExecuteMethod extends Method {
  JexlScriptExecuteMethod() {
    getDeclaringType() instanceof JexlScript and
    hasName("execute")
  }
}

/**
 * A method in the `Callable` class that executes the `Callable`.
 */
private class CallableCallMethod extends Method {
  CallableCallMethod() {
    getDeclaringType() instanceof CallableInterface and
    hasName("call")
  }
}

/**
 * A method in the `JxltEngine.Expression` class that evaluates an expression.
 */
private class JxltEngineExpressionEvaluateMethod extends Method {
  JxltEngineExpressionEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the `JxltEngine.Expression` class that evaluates the immediate sub-expressions.
 */
private class JxltEngineExpressionPrepareMethod extends Method {
  JxltEngineExpressionPrepareMethod() {
    getDeclaringType() instanceof JxltEngineExpression and
    hasName("prepare")
  }
}

/**
 * A method in the `JxltEngine.Template` class that evaluates a template.
 */
private class JxltEngineTemplateEvaluateMethod extends Method {
  JxltEngineTemplateEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineTemplate and
    hasName("evaluate")
  }
}

/**
 * A method in the `UnifiedJEXL.Expression` class that evaluates a template.
 */
private class UnifiedJexlExpressionEvaluateMethod extends Method {
  UnifiedJexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the `UnifiedJEXL.Expression` class that evaluates the immediate sub-expressions.
 */
private class UnifiedJexlExpressionPrepareMethod extends Method {
  UnifiedJexlExpressionPrepareMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and
    hasName("prepare")
  }
}

/**
 * A method in the `UnifiedJEXL.Template` class that evaluates a template.
 */
private class UnifiedJexlTemplateEvaluateMethod extends Method {
  UnifiedJexlTemplateEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlTemplate and
    hasName("evaluate")
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
  JxltEngineExpression() {
    getEnclosingType() instanceof JxltEngine and
    hasName("Expression")
  }
}

private class JxltEngineTemplate extends NestedType {
  JxltEngineTemplate() {
    getEnclosingType() instanceof JxltEngine and
    hasName("Template")
  }
}

private class UnifiedJexlExpression extends NestedType {
  UnifiedJexlExpression() {
    getEnclosingType() instanceof UnifiedJexl and
    hasName("Expression")
  }
}

private class UnifiedJexlTemplate extends NestedType {
  UnifiedJexlTemplate() {
    getEnclosingType() instanceof UnifiedJexl and
    hasName("Template")
  }
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
