/** Provides classes to reason about Expression Langauge (JEXL) injection vulnerabilities. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A sink for Expresssion Language injection vulnerabilities via Jexl,
 * that is, method calls that run evaluation of a JEXL expression.
 */
abstract class JexlEvaluationSink extends DataFlow::ExprNode { }

/** Default sink for JXEL injection vulnerabilities. */
private class DefaultJexlEvaluationSink extends JexlEvaluationSink {
  DefaultJexlEvaluationSink() { sinkNode(this, "jexl") }
}

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the `JexlInjectionFlowConfig`.
 */
class JexlInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for the `JexlInjectionConfig` configuration.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A set of additional taint steps to consider when taint tracking JXEL related data flows. */
private class DefaultJexlInjectionAdditionalTaintStep extends JexlInjectionAdditionalTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    createJexlScriptStep(node1, node2) or
    createJexlExpressionStep(node1, node2) or
    createJexlTemplateStep(node1, node2)
  }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a JEXL expression.
 * It supports both JEXL 2 and 3.
 */
class JexlInjectionConfig extends TaintTracking::Configuration {
  JexlInjectionConfig() { this = "JexlInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JexlEvaluationSink }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JexlInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that creates a JEXL script using an unsafe engine
 * by calling `tainted.createScript(jexlExpr)`.
 */
private predicate createJexlScriptStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() and n2.asExpr() = ma |
    not isSafeEngine(ma.getQualifier()) and
    m instanceof CreateJexlScriptMethod and
    n1.asExpr() = ma.getArgument(0) and
    n1.asExpr().getType() instanceof TypeString
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that creates a JEXL expression using an unsafe engine
 * by calling `tainted.createExpression(jexlExpr)`.
 */
private predicate createJexlExpressionStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() and n2.asExpr() = ma |
    not isSafeEngine(ma.getQualifier()) and
    m instanceof CreateJexlExpressionMethod and
    n1.asExpr() = ma.getAnArgument() and
    n1.asExpr().getType() instanceof TypeString
  )
}

/**
 * Holds if `n1` to `n2` is a dataflow step that creates a JEXL template using an unsafe engine
 * by calling `tainted.createTemplate(jexlExpr)`.
 */
private predicate createJexlTemplateStep(DataFlow::Node n1, DataFlow::Node n2) {
  exists(MethodAccess ma, Method m, RefType taintType |
    m = ma.getMethod() and n2.asExpr() = ma and taintType = n1.asExpr().getType()
  |
    not isSafeEngine(ma.getQualifier()) and
    m instanceof CreateJexlTemplateMethod and
    n1.asExpr() = ma.getArgument([0, 1]) and
    (taintType instanceof TypeString or taintType instanceof Reader)
  )
}

/**
 * Holds if `expr` is a JEXL engine that is configured with a sandbox.
 */
private predicate isSafeEngine(Expr expr) {
  exists(SandboxedJexlFlowConfig config | config.hasFlowTo(DataFlow::exprNode(expr)))
}

/**
 * A configuration for tracking sandboxed JEXL engines.
 */
private class SandboxedJexlFlowConfig extends DataFlow2::Configuration {
  SandboxedJexlFlowConfig() { this = "JexlInjection::SandboxedJexlFlowConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof SandboxedJexlSource }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma, Method m |
      m instanceof CreateJexlScriptMethod or
      m instanceof CreateJexlExpressionMethod or
      m instanceof CreateJexlTemplateMethod
    |
      ma.getMethod() = m and ma.getQualifier() = node.asExpr()
    )
  }

  override predicate isAdditionalFlowStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    createJexlEngineStep(fromNode, toNode)
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
private predicate createJexlEngineStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
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
 * A method that creates a JEXL script.
 */
private class CreateJexlScriptMethod extends Method {
  CreateJexlScriptMethod() {
    this.getDeclaringType() instanceof JexlEngine and this.hasName("createScript")
  }
}

/**
 * A method that creates a JEXL template.
 */
private class CreateJexlTemplateMethod extends Method {
  CreateJexlTemplateMethod() {
    (
      this.getDeclaringType() instanceof JxltEngine or
      this.getDeclaringType() instanceof UnifiedJexl
    ) and
    this.hasName("createTemplate")
  }
}

/**
 * A method that creates a JEXL expression.
 */
private class CreateJexlExpressionMethod extends Method {
  CreateJexlExpressionMethod() {
    (this.getDeclaringType() instanceof JexlEngine or this.getDeclaringType() instanceof JxltEngine) and
    this.hasName("createExpression")
    or
    this.getDeclaringType() instanceof UnifiedJexl and this.hasName("parse")
  }
}

private class JexlRefType extends RefType {
  JexlRefType() {
    this.getPackage().hasName(["org.apache.commons.jexl2", "org.apache.commons.jexl3"])
  }
}

private class JexlBuilder extends JexlRefType {
  JexlBuilder() { this.hasName("JexlBuilder") }
}

private class JexlEngine extends JexlRefType {
  JexlEngine() { this.hasName("JexlEngine") }
}

private class JxltEngine extends JexlRefType {
  JxltEngine() { this.hasName("JxltEngine") }
}

private class UnifiedJexl extends JexlRefType {
  UnifiedJexl() { this.hasName("UnifiedJEXL") }
}

private class JexlUberspect extends Interface {
  JexlUberspect() {
    this.hasQualifiedName("org.apache.commons.jexl2.introspection", "Uberspect") or
    this.hasQualifiedName("org.apache.commons.jexl3.introspection", "JexlUberspect")
  }
}

private class Reader extends RefType {
  Reader() { this.hasQualifiedName("java.io", "Reader") }
}
