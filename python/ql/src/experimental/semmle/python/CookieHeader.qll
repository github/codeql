/**
 * Temporary: provides a class to extend current cookies to header declarations
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.Concepts

class CookieHeader extends HeaderDeclaration, Cookie::Range {
  CookieHeader() {
    this instanceof HeaderDeclaration and
    this.(HeaderDeclaration).getNameArg().asExpr().(Str_).getS() = "Set-Cookie"
  }

  override predicate isSecure() {
    this.(HeaderDeclaration).getValueArg().asExpr().(Str_).getS().regexpMatch(".*; *Secure;.*")
  }

  override predicate isHttpOnly() {
    this.(HeaderDeclaration).getValueArg().asExpr().(Str_).getS().regexpMatch(".*; *HttpOnly;.*")
  }

  override predicate isSameSite() {
    this.(HeaderDeclaration)
        .getValueArg()
        .asExpr()
        .(Str_)
        .getS()
        .regexpMatch(".*; *SameSite=(Strict|Lax);.*")
  }

  override DataFlow::Node getName() { result = this.(HeaderDeclaration).getValueArg() }

  override DataFlow::Node getValue() { result = this.(HeaderDeclaration).getValueArg() }
}
