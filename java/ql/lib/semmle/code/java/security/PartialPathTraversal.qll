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

private class MethodCallFileGetCanonicalPath extends MethodCall {
  MethodCallFileGetCanonicalPath() { this.getMethod() instanceof MethodFileGetCanonicalPath }
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

private predicate isSafe(Expr expr) {
  DataFlow::localExprFlow(any(Expr e |
      e instanceof FileSeparatorAppend or e instanceof FileSeparatorExpr
    ), expr)
}

/**
 * A method access that returns a boolean that incorrectly guards against Partial Path Traversal.
 */
class PartialPathTraversalMethodCall extends MethodCall {
  PartialPathTraversalMethodCall() {
    this.getMethod() instanceof MethodStringStartsWith and
    DataFlow::localExprFlow(any(MethodCallFileGetCanonicalPath gcpma), this.getQualifier()) and
    not isSafe(this.getArgument(0))
  }
}
