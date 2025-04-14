/**
 * Provides classes for working with resource loading in Spring.
 */
deprecated module;

import java
private import semmle.code.java.dataflow.FlowSources

/** A utility class for resolving resource locations to files in the file system in the Spring framework. */
class ResourceUtils extends Class {
  ResourceUtils() { this.hasQualifiedName("org.springframework.util", "ResourceUtils") }
}

/**
 * A method declared in `org.springframework.util.ResourceUtils` that loads Spring resources.
 */
class GetResourceUtilsMethod extends Method {
  GetResourceUtilsMethod() {
    this.getDeclaringType().getASupertype*() instanceof ResourceUtils and
    this.hasName(["extractArchiveURL", "extractJarFileURL", "getFile", "getURL"])
  }
}
