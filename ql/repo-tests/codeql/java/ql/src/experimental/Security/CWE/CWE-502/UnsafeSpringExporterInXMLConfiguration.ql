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
 *       external/cwe/cwe-502
 */

import java
import semmle.code.java.frameworks.spring.SpringBean
import UnsafeSpringExporterLib

from SpringBean bean
where isRemoteInvocationSerializingExporter(bean.getClass())
select bean, "Unsafe deserialization in a Spring exporter bean '" + bean.getBeanIdentifier() + "'"
