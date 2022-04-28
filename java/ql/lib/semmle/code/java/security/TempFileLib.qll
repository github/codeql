/** Provides classes to reason about temporary directory vulnerabilities. */

import java
import semmle.code.java.dataflow.ExternalFlow

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

private class TemporaryFileFlow extends SummaryModelCsv {
  override predicate row(string row) {
    // qualifier to return
    row =
      "java.io;File;true;" + ["getAbsoluteFile", "getCanonicalFile"] +
        ";;;Argument[-1];ReturnValue;taint"
  }
}
