/**
 * @name Unsafe deserialization with Spring's remote service exporters.
 * @description A Spring bean, which is based on RemoteInvocationSerializingExporter,
 *              initializes an endpoint that uses ObjectInputStream to deserialize
 *              incoming data. In the worst case, that may lead to remote code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/unsafe-deserialization-spring-exporter-in-xml-configuration
 * @tags security
 *       experimental
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.frameworks.spring.SpringBean
deprecated import UnsafeSpringExporterLib

deprecated query predicate problems(SpringBean bean, string message) {
  isRemoteInvocationSerializingExporter(bean.getClass()) and
  message = "Unsafe deserialization in a Spring exporter bean '" + bean.getBeanIdentifier() + "'."
}
