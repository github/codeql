/**
 * @name Partial Path Traversal Vulnerability
 * @description A misuse of the String `startsWith` method as a guard to protect against path traversal is insufficient.
 * @kind problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id java/partial-path-traversal
 * @tags security
 *       external/cwe/cwe-023
 */

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
  StringLiteralFileSeparatorExpr() { this.getValue() = "/" }
}

class FileSeparatorAppend extends AddExpr {
  FileSeparatorAppend() { this.getRightOperand() instanceof FileSeparatorExpr }
}

predicate isSafe(Expr expr) { DataFlow::localExprFlow(any(FileSeparatorAppend fsa), expr) }

from MethodAccess ma
where
  ma.getMethod() instanceof MethodStringStartsWith and
  DataFlow::localExprFlow(any(MethodAccessFileGetCanonicalPath gcpma), ma.getQualifier()) and
  not isSafe(ma.getArgument(0))
select ma, "Partial Path Traversal Vulnerability due to insufficient guard against path traversal"
