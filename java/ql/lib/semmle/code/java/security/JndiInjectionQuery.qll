/** Provides taint tracking configurations to be used in JNDI injection queries. */

import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.Jndi
import semmle.code.java.frameworks.SpringLdap
import semmle.code.java.security.JndiInjection
private import semmle.code.java.security.Sanitizers

/**
 * A taint-tracking configuration for unvalidated user input that is used in JNDI lookup.
 */
module JndiInjectionFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof JndiInjectionSink }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof SimpleTypeSanitizer or
    node instanceof JndiInjectionSanitizer
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    any(JndiInjectionAdditionalTaintStep c).step(node1, node2)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/** Tracks flow of unvalidated user input that is used in JNDI lookup */
module JndiInjectionFlow = TaintTracking::Global<JndiInjectionFlowConfig>;

/**
 * A method that does a JNDI lookup when it receives a `SearchControls` argument with `setReturningObjFlag` = `true`
 */
private class UnsafeSearchControlsSink extends JndiInjectionSink {
  UnsafeSearchControlsSink() {
    exists(MethodCall ma | UnsafeSearchControlsFlow::flowToExpr(ma.getAnArgument()) |
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
    exists(MethodCall ma, Method m |
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
    exists(MethodCall ma |
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
