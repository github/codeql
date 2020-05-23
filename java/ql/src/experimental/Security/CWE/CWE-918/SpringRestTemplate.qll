import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Networking

class TypeRestTemplate extends Class {
  TypeRestTemplate() { hasQualifiedName("org.springframework.web.client", "RestTemplate") }
}

class MethodAccessRestTemplate extends MethodAccess {
  MethodAccessRestTemplate() { getMethod().getDeclaringType() instanceof TypeRestTemplate }
}

