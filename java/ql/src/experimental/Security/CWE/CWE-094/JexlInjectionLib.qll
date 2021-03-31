import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a JEXL expression.
 * It supports both JEXL 2 and 3.
 */
class JexlInjectionConfig extends TaintTracking::Configuration {
  JexlInjectionConfig() { this = "JexlInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    any(TaintPropagatingJexlMethodCall c).taintFlow(fromNode, toNode) or
    returnsDataFromBean(fromNode, toNode)
  }
}

/**
 * A sink for Expression Language injection vulnerabilities via Jexl,
 * i.e. method calls that run evaluation of a JEXL expression.
 *
 * Creating a `Callable` from a tainted JEXL expression or script is considered as a sink
 * although the tainted expression is not executed at this point.
 * Here we assume that it will get executed at some point,
 * maybe stored in an object field and then reached by a different flow.
 */
private class JexlEvaluationSink extends DataFlow::ExprNode {
  JexlEvaluationSink() { sinkNode(this, "jexl") }
}

private class JexlEvaluationSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Direct JEXL evaluation
        "org.apache.commons.jexl2;Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlExpression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;Script;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlScript;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JxltEngine$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JxltEngine$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JxltEngine$Template;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Template;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;UnifiedJEXL$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;UnifiedJEXL$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Template;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;UnifiedJEXL$Template;false;evaluate;;;Argument[-1];jexl",
        // JEXL callable
        "org.apache.commons.jexl2;Expression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlExpression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;Script;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlScript;false;callable;;;Argument[-1];jexl",
        // Methods in the `JexlEngine` class that gets or sets a property with a JEXL expression.
        "org.apache.commons.jexl2;JexlEngine;false;getProperty;;;Argument[1..2];jexl",
        "org.apache.commons.jexl3;JexlEngine;false;getProperty;;;Argument[1..2];jexl",
        "org.apache.commons.jexl2;JexlEngine;false;setProperty;;;Argument[1];jexl",
        "org.apache.commons.jexl3;JexlEngine;false;setProperty;;;Argument[1];jexl"
      ]
  }
}

/**
 * Defines method calls that propagate tainted data via one of the methods
 * from JEXL library.
 */
private class TaintPropagatingJexlMethodCall extends MethodAccess {
  Expr taintFromExpr;

  TaintPropagatingJexlMethodCall() {
    exists(Method m, RefType taintType |
      this.getMethod() = m and
      taintType = taintFromExpr.getType()
    |
      isUnsafeEngine(this.getQualifier()) and
      (
        m instanceof CreateJexlScriptMethod and
        taintFromExpr = this.getArgument(0) and
        taintType instanceof TypeString
        or
        m instanceof CreateJexlExpressionMethod and
        taintFromExpr = this.getAnArgument() and
        taintType instanceof TypeString
        or
        m instanceof CreateJexlTemplateMethod and
        (taintType instanceof TypeString or taintType instanceof Reader) and
        taintFromExpr = this.getArgument([0, 1])
      )
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
 * Holds if `expr` is a JEXL engine that is not configured with a sandbox.
 */
private predicate isUnsafeEngine(Expr expr) {
  not exists(SandboxedJexlFlowConfig config | config.hasFlowTo(DataFlow::exprNode(expr)))
}

/**
 * A configuration for a tracking sandboxed JEXL engines.
 */
private class SandboxedJexlFlowConfig extends DataFlow2::Configuration {
  SandboxedJexlFlowConfig() { this = "JexlInjection::SandboxedJexlFlowConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof SandboxedJexlSource }

  override predicate isSink(DataFlow::Node node) { sinkNode(node, "sandboxed-jexl") }

  override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    createsJexlEngine(fromNode, toNode)
  }
}

private class SandboxedJexlEvaluationSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // CreateJexlScriptMethod
        "org.apache.commons.jexl2;JexlEngine;false;createScript;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;JexlEngine;false;createScript;;;Argument[-1];sandboxed-jexl",
        // CreateJexlExpressionMethod
        "org.apache.commons.jexl2;UnifiedJEXL;false;parse;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;UnifiedJEXL;false;parse;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl2;JxltEngine;false;createExpression;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;JxltEngine;false;createExpression;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl2;JexlEngine;false;createExpression;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;JexlEngine;false;createExpression;;;Argument[-1];sandboxed-jexl",
        // CreateJexlTemplateMethod
        "org.apache.commons.jexl2;JxltEngine;false;createTemplate;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;JxltEngine;false;createTemplate;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl2;UnifiedJEXL;false;createTemplate;;;Argument[-1];sandboxed-jexl",
        "org.apache.commons.jexl3;UnifiedJEXL;false;createTemplate;;;Argument[-1];sandboxed-jexl"
      ]
  }
}

/**
 * Defines a data flow source for JEXL engines configured with a sandbox.
 */
private class SandboxedJexlSource extends DataFlow::ExprNode {
  SandboxedJexlSource() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof JexlBuilder and
      m.hasName(["uberspect", "sandbox"]) and
      m.getReturnType() instanceof JexlBuilder and
      this.asExpr() = [ma, ma.getQualifier()]
    )
    or
    exists(ConstructorCall cc |
      cc.getConstructedType() instanceof JexlEngine and
      cc.getArgument(0).getType() instanceof JexlUberspect and
      cc = this.asExpr()
    )
  }
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that creates one of the JEXL engines.
 */
private predicate createsJexlEngine(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    (m.getDeclaringType() instanceof JexlBuilder or m.getDeclaringType() instanceof JexlEngine) and
    m.hasName(["create", "createJxltEngine"]) and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
  or
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof UnifiedJexl and
    cc.getArgument(0) = fromNode.asExpr() and
    cc = toNode.asExpr()
  )
}

/**
 * Holds if `fromNode` to `toNode` is a dataflow step that returns data from
 * a bean by calling one of its getters.
 */
private predicate returnsDataFromBean(DataFlow::Node fromNode, DataFlow::Node toNode) {
  exists(MethodAccess ma, Method m | ma.getMethod() = m |
    m instanceof GetterMethod and
    ma.getQualifier() = fromNode.asExpr() and
    ma = toNode.asExpr()
  )
}

/**
 * A method that creates a JEXL script.
 */
private class CreateJexlScriptMethod extends Method {
  CreateJexlScriptMethod() { getDeclaringType() instanceof JexlEngine and hasName("createScript") }
}

/**
 * A method that creates a JEXL template.
 */
private class CreateJexlTemplateMethod extends Method {
  CreateJexlTemplateMethod() {
    (getDeclaringType() instanceof JxltEngine or getDeclaringType() instanceof UnifiedJexl) and
    hasName("createTemplate")
  }
}

/**
 * A method that creates a JEXL expression.
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

private class JexlBuilder extends JexlRefType {
  JexlBuilder() { hasName("JexlBuilder") }
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

private class JexlUberspect extends Interface {
  JexlUberspect() {
    hasQualifiedName("org.apache.commons.jexl2.introspection", "Uberspect") or
    hasQualifiedName("org.apache.commons.jexl3.introspection", "JexlUberspect")
  }
}

private class Reader extends RefType {
  Reader() { hasQualifiedName("java.io", "Reader") }
}
