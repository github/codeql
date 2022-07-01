/**
 * Provides classes for working with resource loading in Spring.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources

/** A utility class for resolving resource locations to files in the file system in the Spring framework. */
class ResourceUtils extends Class {
  ResourceUtils() { this.hasQualifiedName("org.springframework.util", "ResourceUtils") }
}

/**
 * Resource loading method declared in Spring `ResourceUtils`.
 */
class GetResourceUtilsMethod extends Method {
  GetResourceUtilsMethod() {
    this.getDeclaringType().getASupertype*() instanceof ResourceUtils and
    this.hasName(["extractArchiveURL", "extractJarFileURL", "getFile", "getURL"])
  }
}
