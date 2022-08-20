/** Provides taint tracking configurations to be used in JNDI injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.security.JndiInjection

/**
 * A taint-tracking configuration for unvalidated user input that is used in JNDI lookup.
 */
class JndiInjectionFlowConfig extends TaintTracking::Configuration {
  JndiInjectionFlowConfig() { this = "JndiInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JndiInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JndiInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * A method that does a JNDI lookup when it receives a `SearchControls` argument with `setReturningObjFlag` = `true`
 */
private class UnsafeSearchControlsSink extends JndiInjectionSink {
  UnsafeSearchControlsSink() {
    exists(UnsafeSearchControlsConf conf, MethodAccess ma |
      conf.hasFlowTo(DataFlow::exprNode(ma.getAnArgument()))
    |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * Find flows between a `SearchControls` object with `setReturningObjFlag` = `true`
 * and an argument of an `LdapOperations.search` or `DirContext.search` call.
 */
private class UnsafeSearchControlsConf extends DataFlow2::Configuration {
  UnsafeSearchControlsConf() { this = "UnsafeSearchControlsConf" }

  override predicate isSource(DataFlow::Node source) { source instanceof UnsafeSearchControls }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeSearchControlsArgument }
}

/**
 * An argument of type `SearchControls` of an `LdapOperations.search` or `DirContext.search` call.
 */
private class UnsafeSearchControlsArgument extends DataFlow::ExprNode {
  UnsafeSearchControlsArgument() {
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      ma.getAnArgument() = this.asExpr() and
      this.asExpr().getType() instanceof TypeSearchControls and
      m.hasName("search")
    |
      m.getDeclaringType().getASourceSupertype*() instanceof TypeLdapOperations or
      m.getDeclaringType().getASourceSupertype*() instanceof TypeDirContext
    )
  }
}

/**
 * A `SearchControls` object with `setReturningObjFlag` = `true`.
 */
private class UnsafeSearchControls extends DataFlow::ExprNode {
  UnsafeSearchControls() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof SetReturningObjFlagMethod and
      ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = true and
      this.asExpr() = ma.getQualifier()
    )
    or
    exists(ConstructorCall cc |
      cc.getConstructedType() instanceof TypeSearchControls and
      cc.getArgument(4).(CompileTimeConstantExpr).getBooleanValue() = true and
      this.asExpr() = cc
    )
  }
}

/**
 * The method `SearchControls.setReturningObjFlag`.
 */
private class SetReturningObjFlagMethod extends Method {
  SetReturningObjFlagMethod() {
    this.getDeclaringType() instanceof TypeSearchControls and
    this.hasName("setReturningObjFlag")
  }
}
