/** Provides taint tracking configurations to be used in JNDI injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.security.JndiInjection

/**
 * DEPRECATED: Use `JndiInjectionFlow` instead.
 *
 * A taint-tracking configuration for unvalidated user input that is used in JNDI lookup.
 */
deprecated class JndiInjectionFlowConfig extends TaintTracking::Configuration {
  JndiInjectionFlowConfig() { this = "JndiInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof JndiInjectionSink }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node instanceof JndiInjectionSanitizer
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JndiInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used in JNDI lookup.
 */
module JndiInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof JndiInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType or
    node.getType() instanceof BoxedType or
    node instanceof JndiInjectionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JndiInjectionAdditionalTaintStep c).step(node1, node2)
  }
}

/** Tracks flow of unvalidated user input that is used in JNDI lookup */
module JndiInjectionFlow = TaintTracking::Global<JndiInjectionFlowConfig>;

/**
 * A method that does a JNDI lookup when it receives a `SearchControls` argument with `setReturningObjFlag` = `true`
 */
private class UnsafeSearchControlsSink extends JndiInjectionSink {
  UnsafeSearchControlsSink() {
    exists(MethodAccess ma | UnsafeSearchControlsFlow::flowToExpr(ma.getAnArgument()) |
      this.asExpr() = ma.getArgument(0)
    )
  }
}

/**
 * Find flows between a `SearchControls` object with `setReturningObjFlag` = `true`
 * and an argument of an `LdapOperations.search` or `DirContext.search` call.
 */
private module UnsafeSearchControlsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UnsafeSearchControls }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeSearchControlsArgument }
}

private module UnsafeSearchControlsFlow = DataFlow::Global<UnsafeSearchControlsConfig>;

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
