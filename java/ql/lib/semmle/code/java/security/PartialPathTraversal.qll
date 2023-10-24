/** Provides classes to reason about partial path traversal vulnerabilities. */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.environment.SystemProperty

private class MethodStringStartsWith extends Method {
  MethodStringStartsWith() {
    this.getDeclaringType() instanceof TypeString and
    this.hasName("startsWith")
  }
}

private class MethodFileGetCanonicalPath extends Method {
  MethodFileGetCanonicalPath() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("getCanonicalPath")
  }
}

private class MethodAccessFileGetCanonicalPath extends MethodAccess {
  MethodAccessFileGetCanonicalPath() { this.getMethod() instanceof MethodFileGetCanonicalPath }
}

abstract private class FileSeparatorExpr extends Expr { }

private class SystemPropFileSeparatorExpr extends FileSeparatorExpr {
  SystemPropFileSeparatorExpr() { this = getSystemProperty("file.separator") }
}

private class StringLiteralFileSeparatorExpr extends FileSeparatorExpr, StringLiteral {
  StringLiteralFileSeparatorExpr() {
    this.getValue().matches("%/") or this.getValue().matches("%\\")
  }
}

private class CharacterLiteralFileSeparatorExpr extends FileSeparatorExpr, CharacterLiteral {
  CharacterLiteralFileSeparatorExpr() { this.getValue() = "/" or this.getValue() = "\\" }
}

private class FileSeparatorAppend extends AddExpr {
  FileSeparatorAppend() { this.getRightOperand() instanceof FileSeparatorExpr }
}

private class FileSeperatorAssignAddExpr extends AssignAddExpr {
  FileSeperatorAssignAddExpr() { this.getRhs() instanceof FileSeparatorExpr }
}

private predicate isSafe(Expr expr) {
  DataFlow::localExprFlow(any(Expr e |
      e instanceof FileSeparatorAppend or
      e instanceof FileSeparatorExpr or
      e instanceof FileSeperatorAssignAddExpr
    ), expr)
}

/**
 * Global data flow from File.getCanonicalPath() to any method call.
 */
private module FromGetCanonicalPath implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node.asExpr() instanceof MethodAccessFileGetCanonicalPath
  }

  predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof MethodStringStartsWith and ma.getArgument(0) = node.asExpr()
    )
  }
}

private module FromGetCanonicalPathFlow = DataFlow::Global<FromGetCanonicalPath>;

/**
 * A method access that returns a boolean that incorrectly guards against Partial Path Traversal.
 */
class PartialPathTraversalMethodAccess extends MethodAccess {
  PartialPathTraversalMethodAccess() {
    this.getMethod() instanceof MethodStringStartsWith and
    (
      DataFlow::localExprFlow(any(MethodAccessFileGetCanonicalPath gcpma), this.getQualifier())
      or
      FromGetCanonicalPathFlow::flowToExpr(this.getArgument(0))
    ) and
    not isSafe(this.getArgument(0))
  }
}
