/* Definitions related to the Apache Commons Exec library. */
import semmle.code.java.Type

library class TypeCommandLine extends Class {
  TypeCommandLine() { hasQualifiedName("org.apache.commons.exec", "CommandLine") }
}

library class MethodCommandLineParse extends Method {
  MethodCommandLineParse() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("parse")
  }
}

library class MethodCommandLineAddArguments extends Method {
  MethodCommandLineAddArguments() {
    getDeclaringType() instanceof TypeCommandLine and
    hasName("addArguments")
  }
}
