import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Networking

class TypeRestTemplate extends Class {
  TypeRestTemplate() { hasQualifiedName("org.springframework.web.client", "RestTemplate") }
}

class MethodAccessRestTemplate extends MethodAccess {
  MethodAccessRestTemplate() { getMethod().getDeclaringType() instanceof TypeRestTemplate }
}

class TypeRestOperations extends Interface {
  TypeRestOperations() { hasQualifiedName("org.springframework.web.client", "RestOperations") }
}

class TypeRequestEntity extends ParameterizedClass {
  TypeRequestEntity() { hasQualifiedName("org.springframework.http", "RequestEntity") }
}

class MethodAccessRequestEntity extends MethodAccess {
  MethodAccessRequestEntity() { getMethod().getDeclaringType() instanceof TypeRequestEntity }
}

class RequestEntityConstructor extends ClassInstanceExpr {
  RequestEntityConstructor() { getConstructedType() instanceof TypeRequestEntity }

  Expr uriArg() {
    exists(Expr e |
      getAnArgument() = e and
      e.getType() instanceof TypeUri and
      result = e
    )
  }
}

private predicate taintStepCommon(DataFlow::Node node1, DataFlow::Node node2) {
  exists(RequestEntityConstructor c |
    node1.asExpr() = c.uriArg() and
    node2.asExpr() = c
  )
}

predicate unsafeURLHostFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
}

predicate unsafeURLSpecFlowTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  taintStepCommon(node1, node2)
}

predicate isUnsafeURLFlowSink(DataFlow::Node node) {
  // all methods defined in `org.springframework.web.client.RestOperations`
  // having tainted first argument
  exists(MethodAccessRestTemplate m, Method override, TypeRestOperations restOperations |
    m.getMethod().getSourceDeclaration().overrides*(override) and
    restOperations.getAMethod() = override.getSourceDeclaration() and
    node.asExpr() = m.getArgument(0)
  )
}