/**
 * @name Unsafe deserialization with Spring's remote service exporters.
 * @description A Spring bean, which is based on RemoteInvocationSerializingExporter,
 *              initializes an endpoint that uses ObjectInputStream to deserialize
 *              incoming data. In the worst case, that may lead to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization-spring-exporter-in-configuration-class
 * @tags security
 *       external/cwe/cwe-502
 */

import java
import UnsafeSpringExporterLib

/**
 * A method that initializes a unsafe bean based on `RemoteInvocationSerializingExporter`.
 */
private class UnsafeBeanInitMethod extends Method {
  string identifier;

  UnsafeBeanInitMethod() {
    isRemoteInvocationSerializingExporter(this.getReturnType()) and
    this.getDeclaringType().hasAnnotation("org.springframework.context.annotation", "Configuration") and
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

from UnsafeBeanInitMethod method
select method,
  "Unsafe deserialization in a Spring exporter bean '" + method.getBeanIdentifier() + "'"
