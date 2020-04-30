import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import DataFlow

/**
 * A taint-tracking configuration for disabling revocation checking.
 */
class DisabledRevocationCheckingConfig extends TaintTracking::Configuration {
  DisabledRevocationCheckingConfig() { this = "DisabledRevocationCheckingConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(BooleanLiteral b | b.getBooleanValue() = false | source.asExpr() = b)
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SetRevocationEnabledSink }
}

/**
 * A sink that disables revocation checking,
 * i.e. calling `PKIXParameters.setRevocationEnabled(false)`
 * without setting a custom revocation checker in `PKIXParameters`.
 */
class SetRevocationEnabledSink extends DataFlow::ExprNode {
  SetRevocationEnabledSink() {
    exists(MethodAccess setRevocationEnabledCall |
      setRevocationEnabledCall.getMethod() instanceof SetRevocationEnabledMethod and
      setRevocationEnabledCall.getArgument(0) = getExpr() and
      not exists(
        SettingRevocationCheckerConfig config, DataFlow2::PathNode source, DataFlow2::PathNode sink
      |
        config.hasFlowPath(source, sink) and
        sink.getNode().(SettingRevocationCheckerSink).getVariable() =
          setRevocationEnabledCall.getQualifier().(VarAccess).getVariable()
      )
    )
  }
}

/**
 * A dataflow config for tracking a custom revocation checker.
 */
class SettingRevocationCheckerConfig extends DataFlow2::Configuration {
  SettingRevocationCheckerConfig() {
    this = "DisabledRevocationChecking::SettingRevocationCheckerConfig"
  }

  override predicate isSource(DataFlow::Node source) {
    source instanceof GetRevocationCheckerSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SettingRevocationCheckerSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    createSingletonListStep(node1, node2) or
    convertArrayToListStep(node1, node2) or
    addToListStep(node1, node2)
  }

  override int fieldFlowBranchLimit() { result = 0 }
}

/**
 * A source that creates a custom revocation checker,
 * i.e. `CertPathValidator.getRevocationChecker()`.
 */
class GetRevocationCheckerSource extends DataFlow::ExprNode {
  GetRevocationCheckerSource() {
    exists(MethodAccess ma | ma.getMethod() instanceof GetRevocationCheckerMethod |
      ma = asExpr() or ma.getQualifier() = asExpr()
    )
  }
}

/**
 * A sink that sets a custom revocation checker in `PKIXParameters`,
 * i.e. `PKIXParameters.addCertPathChecker()` or `PKIXParameters.setCertPathCheckers()`.
 */
class SettingRevocationCheckerSink extends DataFlow::ExprNode {
  MethodAccess ma;

  SettingRevocationCheckerSink() {
    (
      ma.getMethod() instanceof AddCertPathCheckerMethod or
      ma.getMethod() instanceof SetCertPathCheckersMethod
    ) and
    ma.getArgument(0) = asExpr()
  }

  Variable getVariable() { result = ma.getQualifier().(VarAccess).getVariable() }
}

/**
 * Holds if `node1` to `node2` is a dataflow step that creates a singleton list,
 * i.e. `Collections.singletonList(element)`.
 */
predicate createSingletonListStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(StaticMethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof Collections and
    m.hasName("singletonList") and
    ma.getArgument(0) = node1.asExpr() and
    (ma = node2.asExpr() or ma.getQualifier() = node2.asExpr())
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that converts an array to a list,class
 * i.e. `Arrays.asList(element)`.
 */
predicate convertArrayToListStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(StaticMethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof Arrays and
    m.hasName("asList") and
    ma.getArgument(0) = node1.asExpr() and
    (ma = node2.asExpr() or ma.getQualifier() = node2.asExpr())
  )
}

/**
 * Holds if `node1` to `node2` is a dataflow step that adds an element to a list,
 * i.e. `list.add(element)` or `list.addAll(elements)`.
 */
predicate addToListStep(DataFlow::Node node1, DataFlow::Node node2) {
  exists(MethodAccess ma, Method m | m = ma.getMethod() |
    m.getDeclaringType() instanceof List and
    (
      m.hasName("add") or
      m.hasName("addAll")
    ) and
    ma.getArgument(0) = node1.asExpr() and
    (ma = node2.asExpr() or ma.getQualifier() = node2.asExpr())
  )
}

class SetRevocationEnabledMethod extends Method {
  SetRevocationEnabledMethod() {
    getDeclaringType() instanceof PKIXParameters and
    hasName("setRevocationEnabled")
  }
}

class GetRevocationCheckerMethod extends Method {
  GetRevocationCheckerMethod() {
    getDeclaringType() instanceof CertPathValidator and
    hasName("getRevocationChecker")
  }
}

class AddCertPathCheckerMethod extends Method {
  AddCertPathCheckerMethod() {
    getDeclaringType() instanceof PKIXParameters and
    hasName("addCertPathChecker")
  }
}

class SetCertPathCheckersMethod extends Method {
  SetCertPathCheckersMethod() {
    getDeclaringType() instanceof PKIXParameters and
    hasName("setCertPathCheckers")
  }
}

class PKIXParameters extends RefType {
  PKIXParameters() { hasQualifiedName("java.security.cert", "PKIXParameters") }
}

class CertPathValidator extends RefType {
  CertPathValidator() { hasQualifiedName("java.security.cert", "CertPathValidator") }
}

class Collections extends RefType {
  Collections() { hasQualifiedName("java.util", "Collections") }
}

class Arrays extends RefType {
  Arrays() { hasQualifiedName("java.util", "Arrays") }
}

class List extends ParameterizedInterface {
  List() { getGenericType().hasQualifiedName("java.util", "List") }
}
