/**
 * Temporary: provides a class to extend current cookies to header declarations
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import experimental.semmle.python.Concepts
import semmle.python.Concepts

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
class CookieHeader extends Cookie::Range instanceof Http::Server::ResponseHeaderWrite {
  CookieHeader() {
    exists(StringLiteral str |
      str.getText() = "Set-Cookie" and
      DataFlow::exprNode(str)
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(Http::Server::ResponseHeaderWrite).getNameArg())
    )
  }

  override predicate isSecure() {
    exists(StringLiteral str |
      str.getText().regexpMatch(".*; *Secure;.*") and
      DataFlow::exprNode(str)
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(Http::Server::ResponseHeaderWrite).getValueArg())
    )
  }

  override predicate isHttpOnly() {
    exists(StringLiteral str |
      str.getText().regexpMatch(".*; *HttpOnly;.*") and
      DataFlow::exprNode(str)
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(Http::Server::ResponseHeaderWrite).getValueArg())
    )
  }

  override predicate isSameSite() {
    exists(StringLiteral str |
      str.getText().regexpMatch(".*; *SameSite=(Strict|Lax);.*") and
      DataFlow::exprNode(str)
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(Http::Server::ResponseHeaderWrite).getValueArg())
    )
  }

  override DataFlow::Node getNameArg() {
    result = this.(Http::Server::ResponseHeaderWrite).getValueArg()
  }

  override DataFlow::Node getValueArg() {
    result = this.(Http::Server::ResponseHeaderWrite).getValueArg()
  }

  override DataFlow::Node getHeaderArg() { none() }
}
