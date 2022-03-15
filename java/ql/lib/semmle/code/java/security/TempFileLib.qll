/** Provides classes to reason about temporary directory vulnerabilities. */

import java
import semmle.code.java.dataflow.ExternalFlow

/**
 * All `java.io.File::createTempFile` methods.
 */
class MethodFileCreateTempFile extends Method {
  MethodFileCreateTempFile() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("createTempFile")
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
