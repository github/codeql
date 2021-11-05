/**
 * Temporary: provides a class to extend current cookies to header declarations
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.Concepts

/**
 * Gets a header setting a cookie.
 *
 * Given the following example:
 *
 * ```py
 * @app.route("/")
 * def flask_make_response():
 *    resp = make_response("")
 *    resp.headers['Set-Cookie'] = "name=value; Secure;"
 *    return resp
 * ```
 *
 * * `this` would be `resp.headers['Set-Cookie'] = "name=value; Secure;"`.
 * * `isSecure()` predicate would succeed.
 * * `isHttpOnly()` predicate would fail.
 * * `isSameSite()` predicate would fail.
 * * `getName()` and `getValue()` results would be `"name=value; Secure;"`.
 */
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
