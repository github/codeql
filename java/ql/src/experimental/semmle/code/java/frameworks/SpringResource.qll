/**
 * Provides classes for working with resource loading in Spring.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources

/** A class for class path resources in the Spring framework. */
class ClassPathResource extends Class {
  ClassPathResource() { this.hasQualifiedName("org.springframework.core.io", "ClassPathResource") }
}

/** An interface for objects that are sources for an InputStream in the Spring framework. */
class InputStreamResource extends RefType {
  InputStreamResource() {
    this.hasQualifiedName("org.springframework.core.io", "InputStreamSource")
  }
}

/** An interface that abstracts from the underlying resource, such as a file or class path resource in the Spring framework. */
class Resource extends RefType {
  Resource() { this.hasQualifiedName("org.springframework.core.io", "Resource") }
}

/** A utility class for resolving resource locations to files in the file system in the Spring framework. */
class ResourceUtils extends Class {
  ResourceUtils() { this.hasQualifiedName("org.springframework.util", "ResourceUtils") }
}

/**
 * The method `getInputStream()` declared in Spring `ClassPathResource`.
 */
class GetClassPathResourceInputStreamMethod extends Method {
  GetClassPathResourceInputStreamMethod() {
    this.getDeclaringType().getASupertype*() instanceof ClassPathResource and
    this.hasName("getInputStream")
  }
}

/**
 * Resource loading method declared in Spring `Resource` with `getInputStream` inherited from the parent interface.
 */
class GetResourceMethod extends Method {
  GetResourceMethod() {
    (
      this.getDeclaringType() instanceof InputStreamResource or
      this.getDeclaringType() instanceof Resource
    ) and
    this.hasName(["getFile", "getFilename", "getInputStream", "getURI", "getURL"])
  }
}

/**
 * Resource loading method declared in Spring `ResourceUtils`.
 */
class GetResourceUtilsMethod extends Method {
  GetResourceUtilsMethod() {
    this.getDeclaringType().getASupertype*() instanceof ResourceUtils and
    this.hasName(["extractArchiveURL", "extractJarFileURL", "getFile", "getURL", "toURI"])
  }
}
