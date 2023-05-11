/** Definitions related to the Apache Commons Exec library. */

import semmle.code.java.Type
import semmle.code.java.security.ExternalProcess

/** The class `org.apache.commons.exec.CommandLine`. */
private class TypeCommandLine extends Class {
  TypeCommandLine() { this.hasQualifiedName("org.apache.commons.exec", "CommandLine") }
}

/** The `parse()` method of the class `org.apache.commons.exec.CommandLine`. */
private class MethodCommandLineParse extends Method, ExecCallable {
  MethodCommandLineParse() {
    this.getDeclaringType() instanceof TypeCommandLine and
    this.hasName("parse")
  }

  override int getAnExecutedArgument() { result = 0 }
}

/** The `addArguments()` method of the class `org.apache.commons.exec.CommandLine`. */
private class MethodCommandLineAddArguments extends Method, ExecCallable {
  MethodCommandLineAddArguments() {
    this.getDeclaringType() instanceof TypeCommandLine and
    this.hasName("addArguments")
  }

  override int getAnExecutedArgument() { result = 0 }
}
