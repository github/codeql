/** Provides classes to reason about temporary directory vulnerabilities. */

import java

/**
 * A `java.io.File::createTempFile` method.
 */
class MethodFileCreateTempFile extends Method {
  MethodFileCreateTempFile() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("createTempFile")
  }
}

/**
 * A method on the class `java.io.File` that create directories.
 */
class MethodFileCreatesDirs extends Method {
  MethodFileCreatesDirs() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName(["mkdir", "mkdirs"])
  }
}
