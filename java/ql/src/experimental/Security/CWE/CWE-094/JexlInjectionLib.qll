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
    source instanceof RemoteFlowSource or
    source instanceof UserInput or
    source instanceof EnvInput
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    createsJexlExpression(node1, node2) or
    createsJexlTemplate(node1, node2) or
    createsJexlScript(node1, node2) or
    createsJexlCallable(node1, node2) or
    returnsDataFromBean(node1, node2)
  }
}

/**
 * A data flow source for parameters that have
 * a Spring framework annotation indicating remote user input from servlets.
 */
class TaintedSpringRequestBody extends DataFlow::Node {
  TaintedSpringRequestBody() {
    exists(SpringServletInputAnnotation a | this.asParameter().getAnAnnotation() = a)
  }
}

/**
 * A sink for Expresssion Language injection vulnerabilities via Jexl,
 * i.e. methods that run evaluation of a Jexl expression.
 */
class JexlEvaluationSink extends DataFlow::ExprNode {
  JexlEvaluationSink() {
    isJexlExpressionEvaluationCall(asExpr()) or
    isJexlTemplateEvaluationCall(asExpr()) or
    isJexlScriptExecuteCall(asExpr()) or
    isJexlGetSetPropertyCall(asExpr()) or
    isCallableCall(asExpr())
  }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates a Jexl expression.
 */
predicate createsJexlExpression(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    (
      m instanceof JxltEngineCreateExpressionMethod or
      m instanceof UnifiedJexlParseMethod or
      m instanceof JexlEngineCreateExpressionMethod
    ) and
    ma.getAnArgument().getType() instanceof TypeString and
    ma.getAnArgument() = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates a Jexl template.
 */
predicate createsJexlTemplate(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    (m instanceof JxltEngineCreateTemplateMethod or m instanceof UnifiedJexlCreateTemplateMethod) and
    (
      node1.asExpr().getType() instanceof TypeString or
      node1.asExpr().getType() instanceof Reader
    ) and
    ma.getArgument([0, 1]) = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * Holds if:
 * - `expr` is the `index`th argument to `ma`
 * - `expr` is a string or an instance of `Reader`
 */
predicate toberemoved(MethodAccess ma, int index, Expr expr) {
  (
    expr.getType() instanceof TypeString or
    expr.getType() instanceof Reader
  ) and
  ma.getArgument(index) = expr
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates a Jexl script.
 */
predicate createsJexlScript(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof JexlEngineCreateScriptMethod and
    ma.getArgument(0).getType() instanceof TypeString and
    ma.getArgument(0) = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step
 * that creates a callable from a Jexl expression or script.
 */
predicate createsJexlCallable(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    (m instanceof JexlExpressionCallableMethod or m instanceof JexlScriptCallableMethod) and
    ma.getQualifier() = node1.asExpr() and
    node2.asExpr() = ma
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that returns data from
 * a tainted bean by calling one of its getters.
 */
predicate returnsDataFromBean(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof GetterMethod and
    ma.getQualifier() = node1.asExpr() and
    ma = node2.asExpr()
  )
}

/**
 * Holds if `expr` calls one of the methods that execute a Jexl script against qualifier `expr`.
 */
predicate isJexlScriptExecuteCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m instanceof JexlScriptExecuteMethod and
    ma.getQualifier() = expr
  )
}

/**
 * Holds if `expr` is the qualifier when calling the `Callable.call()` method
 * such as `expr.call()`.
 */
predicate isCallableCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m instanceof CallableCallMethod and
    ma.getQualifier() = expr
  )
}

/**
 * Holds if `expr` is an argument in a call to one of the methods
 * that get or set a property via a Jexl expression.
 */
predicate isJexlGetSetPropertyCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (m instanceof JexlEngineGetPropertyMethod or m instanceof JexlEngineSetPropertyMethod) and
    ma.getAnArgument().getType() instanceof TypeString and
    ma.getAnArgument() = expr
  )
}

/**
 * Holds if `expr` is a call to one of the methods that trigger evaluation of a Jexl expression.
 */
predicate isJexlExpressionEvaluationCall(Expr expr) {
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
predicate isJexlTemplateEvaluationCall(Expr expr) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (
      m instanceof JxltEngineTemplateEvaluateMethod or
      m instanceof UnifiedJexlTemplateEvaluateMethod
    ) and
    ma.getQualifier() = expr
  )
}

/**
 * A method in the JexlExpression class that evaluates a Jexl expression.
 */
class JexlExpressionEvaluateMethod extends Method {
  JexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof JexlExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the JexlEngine class that creates a Jexl expression.
 */
class JexlEngineCreateExpressionMethod extends Method {
  JexlEngineCreateExpressionMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("createExpression")
  }
}

/**
 * A method in the JexlEngine class that gets a property with a Jexl expression.
 */
class JexlEngineGetPropertyMethod extends Method {
  JexlEngineGetPropertyMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("getProperty")
  }
}

/**
 * A method in the JexlEngine class that sets a property with a Jexl expression.
 */
class JexlEngineSetPropertyMethod extends Method {
  JexlEngineSetPropertyMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("setProperty")
  }
}

/**
 * A method in the JexlEngine class that creates a Jexl script.
 */
class JexlEngineCreateScriptMethod extends Method {
  JexlEngineCreateScriptMethod() {
    getDeclaringType() instanceof JexlEngine and
    hasName("createScript")
  }
}

/**
 * A method in the JexlScript class that executes a Jexl script.
 */
class JexlScriptExecuteMethod extends Method {
  JexlScriptExecuteMethod() {
    getDeclaringType() instanceof JexlScript and
    hasName("execute")
  }
}

/**
 * A method in the JexlScript class that creates a Callable for a Jexl expression.
 */
class JexlExpressionCallableMethod extends Method {
  JexlExpressionCallableMethod() {
    getDeclaringType() instanceof JexlExpression and
    hasName("callable")
  }
}

/**
 * A method in the JexlScript class that creates a Callable for a Jexl script.
 */
class JexlScriptCallableMethod extends Method {
  JexlScriptCallableMethod() {
    getDeclaringType() instanceof JexlScript and
    hasName("callable")
  }
}

/**
 * A method in the Callable class that executes the Callable.
 */
class CallableCallMethod extends Method {
  CallableCallMethod() {
    getDeclaringType() instanceof CallableInterface and
    hasName("call")
  }
}

/**
 * A method in the JxltEngine class that creates an expression.
 */
class JxltEngineCreateExpressionMethod extends Method {
  JxltEngineCreateExpressionMethod() {
    getDeclaringType() instanceof JxltEngine and
    hasName("createExpression")
  }
}

/**
 * A method in the JxltEngine class that creates a template.
 */
class JxltEngineCreateTemplateMethod extends Method {
  JxltEngineCreateTemplateMethod() {
    getDeclaringType() instanceof JxltEngine and
    hasName("createTemplate")
  }
}

/**
 * A method in the JxltEngine.Expression class that evaluates an expression.
 */
class JxltEngineExpressionEvaluateMethod extends Method {
  JxltEngineExpressionEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the JxltEngine.Expression class that evaluates the immediate sub-expressions.
 */
class JxltEngineExpressionPrepareMethod extends Method {
  JxltEngineExpressionPrepareMethod() {
    getDeclaringType() instanceof JxltEngineExpression and
    hasName("prepare")
  }
}

/**
 * A method in the JxltEngine.Template class that evaluates a template.
 */
class JxltEngineTemplateEvaluateMethod extends Method {
  JxltEngineTemplateEvaluateMethod() {
    getDeclaringType() instanceof JxltEngineTemplate and
    hasName("evaluate")
  }
}

/**
 * A method in the UnifiedJEXL class that creates an expression.
 */
class UnifiedJexlParseMethod extends Method {
  UnifiedJexlParseMethod() {
    getDeclaringType() instanceof UnifiedJexl and
    hasName("parse")
  }
}

/**
 * A method in the UnifiedJEXL class that creates a template.
 */
class UnifiedJexlCreateTemplateMethod extends Method {
  UnifiedJexlCreateTemplateMethod() {
    getDeclaringType() instanceof UnifiedJexl and
    hasName("createTemplate")
  }
}

/**
 * A method in the UnifiedJEXL.Expression class that evaluates a template.
 */
class UnifiedJexlExpressionEvaluateMethod extends Method {
  UnifiedJexlExpressionEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and
    hasName("evaluate")
  }
}

/**
 * A method in the UnifiedJEXL.Expression class that evaluates the immediate sub-expressions.
 */
class UnifiedJexlExpressionPrepareMethod extends Method {
  UnifiedJexlExpressionPrepareMethod() {
    getDeclaringType() instanceof UnifiedJexlExpression and
    hasName("prepare")
  }
}

/**
 * A method in the UnifiedJEXL.Template class that evaluates a template.
 */
class UnifiedJexlTemplateEvaluateMethod extends Method {
  UnifiedJexlTemplateEvaluateMethod() {
    getDeclaringType() instanceof UnifiedJexlTemplate and
    hasName("evaluate")
  }
}

class JexlExpression extends RefType {
  JexlExpression() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlExpression") or
    hasQualifiedName("org.apache.commons.jexl2", "Expression")
  }
}

class JexlScript extends RefType {
  JexlScript() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlScript") or
    hasQualifiedName("org.apache.commons.jexl2", "Script")
  }
}

class JexlEngine extends RefType {
  JexlEngine() {
    hasQualifiedName("org.apache.commons.jexl3", "JexlEngine") or
    hasQualifiedName("org.apache.commons.jexl2", "JexlEngine")
  }
}

class JxltEngine extends RefType {
  JxltEngine() { hasQualifiedName("org.apache.commons.jexl3", "JxltEngine") }
}

class UnifiedJexl extends RefType {
  UnifiedJexl() { hasQualifiedName("org.apache.commons.jexl2", "UnifiedJEXL") }
}

class JxltEngineExpression extends NestedType {
  JxltEngineExpression() {
    getEnclosingType() instanceof JxltEngine and
    hasName("Expression")
  }
}

class JxltEngineTemplate extends NestedType {
  JxltEngineTemplate() {
    getEnclosingType() instanceof JxltEngine and
    hasName("Template")
  }
}

class UnifiedJexlExpression extends NestedType {
  UnifiedJexlExpression() {
    getEnclosingType() instanceof UnifiedJexl and
    hasName("Expression")
  }
}

class UnifiedJexlTemplate extends NestedType {
  UnifiedJexlTemplate() {
    getEnclosingType() instanceof UnifiedJexl and
    hasName("Template")
  }
}

class CallableInterface extends RefType {
  CallableInterface() {
    getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName("java.util.concurrent", "Callable")
  }
}

class Reader extends RefType {
  Reader() { hasQualifiedName("java.io", "Reader") }
}
