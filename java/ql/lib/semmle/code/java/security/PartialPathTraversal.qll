import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.environment.SystemProperty

class MethodStringStartsWith extends Method {
  MethodStringStartsWith() {
    this.getDeclaringType() instanceof TypeString and
    this.hasName("startsWith")
  }
}

class MethodFileGetCanonicalPath extends Method {
  MethodFileGetCanonicalPath() {
    this.getDeclaringType() instanceof TypeFile and
    this.hasName("getCanonicalPath")
  }
}

class MethodAccessFileGetCanonicalPath extends MethodAccess {
  MethodAccessFileGetCanonicalPath() { this.getMethod() instanceof MethodFileGetCanonicalPath }
}

abstract class FileSeparatorExpr extends Expr { }

class SystemPropFileSeparatorExpr extends FileSeparatorExpr {
  SystemPropFileSeparatorExpr() { this = getSystemProperty("file.separator") }
}

class StringLiteralFileSeparatorExpr extends FileSeparatorExpr, StringLiteral {
  StringLiteralFileSeparatorExpr() {
    this.getValue().matches("%/") or this.getValue().matches("%\\")
  }
}

class CharacterLiteralFileSeparatorExpr extends FileSeparatorExpr, CharacterLiteral {
  CharacterLiteralFileSeparatorExpr() { this.getValue() = "/" or this.getValue() = "\\" }
}

class FileSeparatorAppend extends AddExpr {
  FileSeparatorAppend() { this.getRightOperand() instanceof FileSeparatorExpr }
}

predicate isSafe(Expr expr) {
  DataFlow::localExprFlow(any(Expr e |
      e instanceof FileSeparatorAppend or e instanceof FileSeparatorExpr
    ), expr)
}

class PartialPathTraversalMethodAccess extends MethodAccess {
  PartialPathTraversalMethodAccess() {
    this.getMethod() instanceof MethodStringStartsWith and
    DataFlow::localExprFlow(any(MethodAccessFileGetCanonicalPath gcpma), this.getQualifier()) and
    not isSafe(this.getArgument(0))
  }
}
