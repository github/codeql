import java
import semmle.code.java.dataflow.FlowSources
import DataFlow
import experimental.semmle.code.java.frameworks.Jndi
import experimental.semmle.code.java.frameworks.spring.SpringJndi
import experimental.semmle.code.java.frameworks.Shiro

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
    compositeNameStep(node1, node2)
  }
}

/**
 * JNDI sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup`, `lookupLink`,
 * `doLookup`, `rename`, `list` or `listBindings` method from `InitialContext`.
 */
predicate jndiSinkMethod(Method m, int index) {
  m.getDeclaringType().getAnAncestor() instanceof TypeInitialContext and
  (
    m.hasName("lookup") or
    m.hasName("lookupLink") or
    m.hasName("doLookup") or
    m.hasName("rename") or
    m.hasName("list") or
    m.hasName("listBindings")
  ) and
  index = 0
}

/**
 * Spring sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup` method from
 * Spring's `JndiTemplate`.
 */
predicate springSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeSpringJndiTemplate and
  m.hasName("lookup") and
  index = 0
}

/**
 * Apache Shiro sink for JNDI injection vulnerabilities, i.e. 1st argument to `lookup` method from
 * Shiro's `JndiTemplate`.
 */
predicate shiroSinkMethod(Method m, int index) {
  m.getDeclaringType() instanceof TypeShiroJndiTemplate and
  m.hasName("lookup") and
  index = 0
}

/** Holds if parameter at index `index` in method `m` is JNDI injection sink. */
predicate jndiInjectionSinkMethod(Method m, int index) {
  jndiSinkMethod(m, index) or
  springSinkMethod(m, index) or
  shiroSinkMethod(m, index)
}

/** A data flow sink for unvalidated user input that is used in JNDI lookup. */
class JndiInjectionSink extends DataFlow::ExprNode {
  JndiInjectionSink() {
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr() and
      jndiInjectionSinkMethod(m, index)
    )
  }
}

/**
 * Holds if `n1` to `n2` is a dataflow step that converts between `String` and `CompositeName`,
 * i.e. `new CompositeName(tainted)`.
 */
predicate compositeNameStep(ExprNode n1, ExprNode n2) {
  exists(ConstructorCall cc | cc.getConstructedType() instanceof TypeCompositeName |
    n1.asExpr() = cc.getAnArgument() and
    n2.asExpr() = cc
  )
}
