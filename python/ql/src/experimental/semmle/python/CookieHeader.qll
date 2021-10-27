/**
 * Temporary: provides a class to extend current cookies to header declarations
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.Concepts

class CookieHeader extends HeaderDeclaration, Cookie::Range {
  CookieHeader() {
    this instanceof HeaderDeclaration and this.getNameArg().asExpr().(Str_).getS() = "Set-Cookie"
  }

  override predicate isSecure() {
    this.getValueArg().asExpr().(Str_).getS().regexpMatch(".*; *Secure;.*")
  }

  override predicate isHttpOnly() {
    this.getValueArg().asExpr().(Str_).getS().regexpMatch(".*; *HttpOnly;.*")
  }

  override predicate isSameSite() {
    this.getValueArg().asExpr().(Str_).getS().regexpMatch(".*; *SameSite=(Strict|Lax);.*")
  }
}
