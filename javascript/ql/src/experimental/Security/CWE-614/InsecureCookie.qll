/**
 * Provides classes for reasoning about cookies added to response without the 'secure' flag being set.
 * A cookie without the 'secure' flag being set can be intercepted and read by a malicious user.
 */

import javascript

module InsecureCookie {
  /**
   * `secure` property of the cookie options.
   */
  string flag() { result = "secure" }

  /**
   * Abstract class to represent different cases of insecure cookie settings.
   */
  abstract class InsecureCookies extends DataFlow::Node {
    /**
     * Gets the name of the middleware/library used to set the cookie.
     */
    abstract string getKind();

    /**
     * Gets the options used to set this cookie, if any.
     */
    abstract DataFlow::Node getCookieOptionsArgument();

    /**
     * Predicate that determines if a cookie is insecure.
     */
    abstract predicate isInsecure();
  }

  /**
   * A cookie set using the `express` module `cookie-session` (https://github.com/expressjs/cookie-session).
   */
  class InsecureCookieSession extends ExpressLibraries::CookieSession::MiddlewareInstance,
    InsecureCookies {
    InsecureCookieSession() { this instanceof ExpressLibraries::CookieSession::MiddlewareInstance }

    override string getKind() { result = "cookie-session" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.getOption("cookie")
    }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isInsecure() { 
        // A cookie is insecure if the `secure` flag is explicitly set to `false`.
        getCookieFlagValue(flag()).mayHaveBooleanValue(false)
    }
  }

  /**
   * A cookie set using the `express` module `express-session` (https://github.com/expressjs/session).
   */
  class InsecureExpressSessionCookie extends ExpressLibraries::ExpressSession::MiddlewareInstance,
    InsecureCookies {
    override string getKind() { result = "express-session" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.getOption("cookie")
    }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isInsecure() {
        // A cookie is insecure if there are not cookie options with the `secure` flag set to `true`.
      not getCookieFlagValue(flag()).mayHaveBooleanValue(true) and
      not getCookieFlagValue(flag()).mayHaveStringValue("auto")
    }
  }

  /**
   * A cookie set using `response.cookie` from `express` module (https://expressjs.com/en/api.html#res.cookie).
   */
  class InsecureExpressCookieResponse extends InsecureCookies {
    InsecureExpressCookieResponse() {
      this = any(Express::ResponseExpr response).flow().getALocalSource().getAMethodCall("cookie")
    }

    override string getKind() { result = "response.cookie" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.(DataFlow::InvokeNode).getLastArgument().getALocalSource()
    }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isInsecure() {
        // A cookie is insecure if there are not cookie options with the `secure` flag set to `true`.

      not getCookieFlagValue(flag()).mayHaveBooleanValue(true)    
    }
  }

  /**
   * A cookie set using `Set-Cookie` header of an `HTTP` response (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie).
   */
  class InsecureSetCookieHeader extends InsecureCookies {
    InsecureSetCookieHeader() {
      this.asExpr() = any(HTTP::SetCookieHeader setCookie).getHeaderArgument()
    }

    override string getKind() { result = "set-cookie header" }

    override DataFlow::Node getCookieOptionsArgument() {
      result.asExpr() = this.asExpr().(ArrayExpr).getAnElement()
    }

    override predicate isInsecure() {
        // A cookie is insecure if the 'secure' flag is not specified in the cookie definition.
      not exists(string s |
        getCookieOptionsArgument().mayHaveStringValue(s) and
        s.matches("%; secure%")
      )
    }
  }

  /**
   * A cookie set using `js-cookie` library (https://github.com/js-cookie/js-cookie).
   */
  class InsecureJsCookie extends InsecureCookies {
    InsecureJsCookie() {
      this = DataFlow::globalVarRef("Cookie").getAMemberCall("set") or
      this = DataFlow::globalVarRef("Cookie").getAMemberCall("noConflict").getAMemberCall("set") or
      this = DataFlow::moduleMember("js-cookie", "set").getACall()
    }

    override string getKind() { result = "js-cookie" }

    override DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.(DataFlow::CallNode).getArgument(2).getALocalSource()
    }

    DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isInsecure() {
        // A cookie is insecure if there are not cookie options with the `secure` flag set to `true`.
      not getCookieFlagValue(flag()).mayHaveBooleanValue(true)
    }
  }
}
