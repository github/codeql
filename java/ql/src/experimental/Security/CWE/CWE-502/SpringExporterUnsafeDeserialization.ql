/**
 * @name Unsafe deserialization with Spring's remote service exporters.
 * @description A Spring bean, which is based on RemoteInvocationSerializingExporter,
 *              initializes an endpoint that uses ObjectInputStream to deserialize
 *              incoming data. In the worst case, that may lead to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-exporter-unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.frameworks.spring.SpringBean

/**
 * Holds if `type` is `RemoteInvocationSerializingExporter`.
 */
private predicate isRemoteInvocationSerializingExporter(RefType type) {
  type.getASupertype*()
      .hasQualifiedName("org.springframework.remoting.rmi", "RemoteInvocationSerializingExporter")
}

/**
 * Holds if `method` belongs to a Spring configuration.
 */
private predicate isInConfiguration(Method method) {
  method.getDeclaringType().hasAnnotation("org.springframework.context.annotation", "Configuration")
}

/**
 * A method that initializes a unsafe bean based on `RemoteInvocationSerializingExporter`.
 */
private class UnsafeBeanInitMethod extends Method {
  string identifier;

  UnsafeBeanInitMethod() {
    isInConfiguration(this) and
    isRemoteInvocationSerializingExporter(this.getReturnType()) and
    exists(Annotation a |
      a.getType().hasQualifiedName("org.springframework.context.annotation", "Bean")
    |
      this.getAnAnnotation() = a and
      if a.getValue("name") instanceof StringLiteral
      then identifier = a.getValue("name").(StringLiteral).getRepresentedString()
      else identifier = this.getName()
    )
  }

  string getBeanIdentifier() { result = identifier }
}

from File file, string identifier
where
  exists(UnsafeBeanInitMethod method |
    file = method.getFile() and
    identifier = method.getBeanIdentifier()
  )
  or
  exists(SpringBean bean |
    isRemoteInvocationSerializingExporter(bean.getClass()) and
    file = bean.getFile() and
    identifier = bean.getBeanIdentifier()
  )
select file, "Unsafe deserialization in Spring exporter bean '" + identifier + "'"
