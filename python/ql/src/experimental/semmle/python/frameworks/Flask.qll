/**
 * Provides classes modeling security-relevant aspects of the `flask` PyPI package.
 * See https://flask.palletsprojects.com/en/1.1.x/.
 */

private import python
private import semmle.python.frameworks.Flask
private import semmle.python.dataflow.new.DataFlow
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.Flask

module ExperimentalFlask {
  /**
   * Gets a call to `set_cookie()`.
   *
   * Given the following example:
   *
   * ```py
   * @app.route("/")
   * def false():
   *    resp = make_response()
   *    resp.set_cookie("name", value="value", secure=True, httponly=True, samesite='Lax')
   *    return resp
   * ```
   *
   * * `this` would be `resp.set_cookie("name", value="value", secure=False, httponly=False, samesite='None')`.
   * * `getName()`'s result would be `"name"`.
   * * `getValue()`'s result would be `"value"`.
   * * `isSecure()` predicate would succeed.
   * * `isHttpOnly()` predicate would succeed.
   * * `isSameSite()` predicate would succeed.
   */
  class FlaskSetCookieCall extends Cookie::Range instanceof Flask::FlaskResponseSetCookieCall {
    override DataFlow::Node getNameArg() { result = this.getNameArg() }

    override DataFlow::Node getValueArg() { result = this.getValueArg() }

    override predicate isSecure() {
      DataFlow::exprNode(any(True t))
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("secure"))
    }

    override predicate isHttpOnly() {
      DataFlow::exprNode(any(True t))
          .(DataFlow::LocalSourceNode)
          .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("httponly"))
    }

    override predicate isSameSite() {
      exists(StringLiteral str |
        str.getText() in ["Strict", "Lax"] and
        DataFlow::exprNode(str)
            .(DataFlow::LocalSourceNode)
            .flowsTo(this.(DataFlow::CallCfgNode).getArgByName("samesite"))
      )
    }

    override DataFlow::Node getHeaderArg() { none() }
  }
}
