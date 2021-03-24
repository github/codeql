import java

/**
 * Holds if `type` is `RemoteInvocationSerializingExporter`.
 */
predicate isRemoteInvocationSerializingExporter(RefType type) {
  type.getASupertype*()
      .hasQualifiedName("org.springframework.remoting.rmi", "RemoteInvocationSerializingExporter")
}
