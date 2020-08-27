/**
 * Provides classes for reasoning about cookies added to response without the 'secure' flag being set.
 * A cookie without the 'secure' flag being set can be intercepted and read by a malicious user.
 */

import javascript

module Cookie {
  /**
   * `secure` property of the cookie options.
   */
  string flag() { result = "secure" }

  /**
   * Abstract class to represent different cases of insecure cookie settings.
   */
  abstract class Cookie extends DataFlow::Node {
    /**
     * Gets the name of the middleware/library used to set the cookie.
     */
    abstract string getKind();

    /**
     * Gets the options used to set this cookie, if any.
     */
    abstract DataFlow::Node getCookieOptionsArgument();

    /**
     * Holds if this cookie is secure.
     */
    abstract predicate isSecure();
  }

  /**
   * A cookie set using the `express` module `cookie-session` (https://github.com/expressjs/cookie-session).
   */
  class InsecureCookieSession extends ExpressLibraries::CookieSession::MiddlewareInstance, Cookie {
    override string getKind() { result = "cookie-session" }

    override DataFlow::SourceNode getCookieOptionsArgument() { result = this.getOption("cookie") }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // The flag `secure` is set to `false` by default for HTTP, `true` by default for HTTPS (https://github.com/expressjs/cookie-session#cookie-options).
      // A cookie is secure if the `secure` flag is not explicitly set to `false`.
      not getCookieFlagValue(flag()).mayHaveBooleanValue(false)
    }
  }

  /**
   * A cookie set using the `express` module `express-session` (https://github.com/expressjs/session).
   */
  class InsecureExpressSessionCookie extends ExpressLibraries::ExpressSession::MiddlewareInstance,
    Cookie {
    override string getKind() { result = "express-session" }

    override DataFlow::SourceNode getCookieOptionsArgument() { result = this.getOption("cookie") }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // The flag `secure` is not set by default (https://github.com/expressjs/session#Cookieecure).
      // The default value for cookie options is { path: '/', httpOnly: true, secure: false, maxAge: null }.
      // A cookie is secure if there are the cookie options with the `secure` flag set to `true` or to `auto`.
      getCookieFlagValue(flag()).mayHaveBooleanValue(true) or
      getCookieFlagValue(flag()).mayHaveStringValue("auto")
    }
  }

  /**
   * A cookie set using `response.cookie` from `express` module (https://expressjs.com/en/api.html#res.cookie).
   */
  class InsecureExpressCookieResponse extends Cookie, DataFlow::MethodCallNode {
    InsecureExpressCookieResponse() { this.calls(any(Express::ResponseExpr r).flow(), "cookie") }

    override string getKind() { result = "response.cookie" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.getLastArgument().getALocalSource()
    }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      getCookieFlagValue(flag()).mayHaveBooleanValue(true)
    }
  }

  /**
   * A cookie set using `Set-Cookie` header of an `HTTP` response (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie).
   */
  class InsecureSetCookieHeader extends Cookie {
    InsecureSetCookieHeader() {
      this.asExpr() = any(HTTP::SetCookieHeader setCookie).getHeaderArgument()
    }

    override string getKind() { result = "set-cookie header" }

    override DataFlow::Node getCookieOptionsArgument() {
      result.asExpr() = this.asExpr().(ArrayExpr).getAnElement()
    }

    override predicate isSecure() {
      // A cookie is secure if the 'secure' flag is specified in the cookie definition.
      exists(string s |
        getCookieOptionsArgument().mayHaveStringValue(s) and
        s.regexpMatch("(.*;)?\\s*secure.*")
      )
    }
  }

  /**
   * A cookie set using `js-cookie` library (https://github.com/js-cookie/js-cookie).
   */
  class InsecureJsCookie extends Cookie {
    InsecureJsCookie() {
      this =
        [DataFlow::globalVarRef("Cookie"),
            DataFlow::globalVarRef("Cookie").getAMemberCall("noConflict"),
            DataFlow::moduleImport("js-cookie")].getAMemberCall("set")
    }

    override string getKind() { result = "js-cookie" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.(DataFlow::CallNode).getAnArgument().getALocalSource()
    }

    DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      getCookieFlagValue(flag()).mayHaveBooleanValue(true)
    }
  }
}
