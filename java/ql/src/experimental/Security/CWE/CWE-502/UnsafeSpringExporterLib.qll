deprecated module;

import java

/**
 * Holds if `type` is `RemoteInvocationSerializingExporter`.
 */
predicate isRemoteInvocationSerializingExporter(RefType type) {
  type.getAnAncestor()
      .hasQualifiedName("org.springframework.remoting.rmi",
        ["RemoteInvocationSerializingExporter", "RmiBasedExporter"]) or
  type.getAnAncestor().hasQualifiedName("org.springframework.remoting.caucho", "HessianExporter")
}
