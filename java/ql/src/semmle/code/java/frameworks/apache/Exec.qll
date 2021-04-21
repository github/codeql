/* Definitions related to the Apache Commons Exec library. */
import semmle.code.java.Type
import semmle.code.java.security.ExternalProcess

library class TypeCommandLine extends Class {
  TypeCommandLine() { hasQualifiedName("org.apache.commons.exec", "CommandLine") }
}

library class MethodCommandLineParse extends ExecMethod {
  MethodCommandLineParse() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("parse")
  }
}

library class MethodCommandLineAddArguments extends ExecMethod {
  MethodCommandLineAddArguments() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("addArguments")
  }
}
