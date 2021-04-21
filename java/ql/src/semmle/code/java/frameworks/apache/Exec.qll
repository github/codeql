/* Definitions related to the Apache Commons Exec library. */
import semmle.code.java.Type
import semmle.code.java.security.ExternalProcess

library class TypeCommandLine extends Class {
  TypeCommandLine() { hasQualifiedName("org.apache.commons.exec", "CommandLine") }
}

library class MethodCommandLineParse extends Method, ExecCallable {
  MethodCommandLineParse() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("parse")
  }

  override int getAnExecutedArgument() { result = 0 }
}

library class MethodCommandLineAddArguments extends Method, ExecCallable {
  MethodCommandLineAddArguments() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("addArguments")
  }

  override int getAnExecutedArgument() { result = 0 }
}
