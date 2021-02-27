/**
 * @name Unsafe deserialization with spring's remote service exporters.
 * @description Creating a bean based on RemoteInvocationSerializingExporter
 *              may lead to arbitrary code execution.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/spring-exporter-unsafe-deserialization
 * @tags security
 *       external/cwe/cwe-502
 */

import java

/**
 * Holds if `method` initializes a bean.
 */
private predicate createsBean(Method method) {
  method.hasAnnotation("org.springframework.context.annotation", "Bean")
}

/**
 * Holds if `type` is `RemoteInvocationSerializingExporter`.
 */
private predicate isRemoteInvocationSerializingExporter(RefType type) {
  type.hasQualifiedName("org.springframework.remoting.rmi", "RemoteInvocationSerializingExporter")
}

/**
 * Holds if `method` returns an object that extends `RemoteInvocationSerializingExporter`.
 */
private predicate returnsRemoteInvocationSerializingExporter(Method method) {
  isRemoteInvocationSerializingExporter(method.getReturnType().(RefType).getASupertype*())
}

/**
 * Holds if `method` belongs to a Spring configuration.
 */
private predicate isInConfiguration(Method method) {
  method.getDeclaringType().hasAnnotation("org.springframework.context.annotation", "Configuration")
}

/**
 * Holds if `method` initializes a bean that is based on `RemoteInvocationSerializingExporter`.
 */
private predicate createsRemoteInvocationSerializingExporterBean(Method method) {
  isInConfiguration(method) and
  createsBean(method) and
  returnsRemoteInvocationSerializingExporter(method)
}

from Method method
where createsRemoteInvocationSerializingExporterBean(method)
select method,
  "Unasafe deserialization in a remote service exporter in '" + method.getName() + "' method"
