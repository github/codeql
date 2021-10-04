/**
 * Provides classes for reasoning about cookies added to response without the 'secure' or 'httponly' flag being set.
 * - A cookie without the 'secure' flag being set can be intercepted and read by a malicious user.
 * - A cookie without the 'httponly' flag being set can be read by maliciously injected JavaScript.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

// TODO: Move this entire file into stdlib.
// TODO: make "session", "auth", a sensitive name.
// TODO: Have helper predicate that selects the relevant Sensitive Classifications.
// TODO: Look for more cookie libraries.
module Cookie {
  /**
   * `secure` property of the cookie options.
   */
  string secureFlag() { result = "secure" }

  /**
   * `httpOnly` property of the cookie options.
   */
  string httpOnlyFlag() { result = "httpOnly" }

  /**
   * A write to a cookie.
   */
  abstract class CookieWrite extends DataFlow::Node {
    /**
     * Holds if this cookie is secure, i.e. only transmitted over SSL.
     */
    abstract predicate isSecure();

    /**
     * Holds if this cookie is HttpOnly, i.e. not accessible by JavaScript.
     */
    abstract predicate isHttpOnly();

    /**
     * Holds if the cookie is likely an authentication cookie or otherwise sensitive.
     */
    abstract predicate isSensitive();
  }

  /**
   * A cookie set using the `express` module `cookie-session` (https://github.com/expressjs/cookie-session).
   */
  class InsecureCookieSession extends ExpressLibraries::CookieSession::MiddlewareInstance,
    CookieWrite {
    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getOptionArgument(0, flag)
    }

    override predicate isSecure() {
      // The flag `secure` is set to `false` by default for HTTP, `true` by default for HTTPS (https://github.com/expressjs/cookie-session#cookie-options).
      // A cookie is secure if the `secure` flag is not explicitly set to `false`.
      not getCookieFlagValue(secureFlag()).mayHaveBooleanValue(false)
    }

    override predicate isSensitive() {
      any() // It is a session cookie, likely auth sensitive
    }

    override predicate isHttpOnly() {
      // The flag `httpOnly` is set to `true` by default (https://github.com/expressjs/cookie-session#cookie-options).
      // A cookie is httpOnly if the `httpOnly` flag is not explicitly set to `false`.
      not getCookieFlagValue(httpOnlyFlag()).mayHaveBooleanValue(false)
    }
  }

  /**
   * A cookie set using the `express` module `express-session` (https://github.com/expressjs/session).
   */
  class InsecureExpressSessionCookie extends ExpressLibraries::ExpressSession::MiddlewareInstance,
    CookieWrite {
    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getOption("cookie").getALocalSource().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // The flag `secure` is not set by default (https://github.com/expressjs/session#Cookiesecure).
      // The default value for cookie options is { path: '/', httpOnly: true, secure: false, maxAge: null }.
      // A cookie is secure if there are the cookie options with the `secure` flag set to `true` or to `auto`.
      getCookieFlagValue(secureFlag()).mayHaveBooleanValue(true) or
      getCookieFlagValue(secureFlag()).mayHaveStringValue("auto")
    }

    override predicate isSensitive() {
      any() // It is a session cookie, likely auth sensitive
    }

    override predicate isHttpOnly() {
      // The flag `httpOnly` is set by default (https://github.com/expressjs/session#Cookiesecure).
      // The default value for cookie options is { path: '/', httpOnly: true, secure: false, maxAge: null }.
      // A cookie is httpOnly if the `httpOnly` flag is not explicitly set to `false`.
      not getCookieFlagValue(httpOnlyFlag()).mayHaveBooleanValue(false)
    }
  }

  /**
   * A cookie set using `response.cookie` from `express` module (https://expressjs.com/en/api.html#res.cookie).
   */
  class InsecureExpressCookieResponse extends CookieWrite, DataFlow::MethodCallNode {
    InsecureExpressCookieResponse() { this.calls(any(Express::ResponseExpr r).flow(), "cookie") }

    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getOptionArgument(this.getNumArgument() - 1, flag)
    }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      // The default is `false`.
      getCookieFlagValue(secureFlag()).mayHaveBooleanValue(true)
    }

    override predicate isSensitive() {
      HeuristicNames::nameIndicatesSensitiveData(any(string s |
          this.getArgument(0).mayHaveStringValue(s)
        ), _)
      or
      this.getArgument(0).asExpr() instanceof SensitiveExpr
    }

    override predicate isHttpOnly() {
      // A cookie is httpOnly if there are cookie options with the `httpOnly` flag set to `true`.
      // The default is `false`.
      getCookieFlagValue(httpOnlyFlag()).mayHaveBooleanValue(true)
    }
  }

  /**
   * A cookie set using `Set-Cookie` header of an `HTTP` response.
   * (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie).
   * In case an array is passed `setHeader("Set-Cookie", [...]` it sets multiple cookies.
   * Each array element has its own attributes.
   */
  class InsecureSetCookieHeader extends CookieWrite {
    InsecureSetCookieHeader() {
      this.asExpr() = any(HTTP::SetCookieHeader setCookie).getHeaderArgument() and
      not this instanceof DataFlow::ArrayCreationNode
      or
      this =
        any(HTTP::SetCookieHeader setCookie)
            .getHeaderArgument()
            .flow()
            .(DataFlow::ArrayCreationNode)
            .getAnElement()
    }

    /**
     * A cookie is secure if the `secure` flag is specified in the cookie definition.
     * The default is `false`.
     */
    override predicate isSecure() { hasCookieAttribute("secure") }

    /**
     * A cookie is httpOnly if the `httpOnly` flag is specified in the cookie definition.
     * The default is `false`.
     */
    override predicate isHttpOnly() { hasCookieAttribute(httpOnlyFlag()) }

    /**
     * The predicate holds only if any element have the specified attribute.
     */
    bindingset[attribute]
    private predicate hasCookieAttribute(string attribute) {
      exists(string s |
        this.mayHaveStringValue(s) and
        hasCookieAttribute(s, attribute)
      )
    }

    /**
     * The predicate holds only if any element has a sensitive name.
     */
    override predicate isSensitive() {
      HeuristicNames::nameIndicatesSensitiveData(getCookieName([
            any(string s | this.mayHaveStringValue(s)),
            this.(StringOps::ConcatenationRoot).getConstantStringParts()
          ]), _)
    }

    /**
     * Gets cookie name from a `Set-Cookie` header value.
     * The header value always starts with `<cookie-name>=<cookie-value>` optionally followed by attributes:
     * `<cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly`
     */
    bindingset[s]
    private string getCookieName(string s) {
      result = s.regexpCapture("\\s*\\b([^=\\s]*)\\b\\s*=.*", 1)
    }

    /**
     * Holds if the `Set-Cookie` header value contains the specified attribute
     * 1. The attribute is case insensitive
     * 2. It always starts with a pair `<cookie-name>=<cookie-value>`.
     *    If the attribute is present there must be `;` after the pair.
     *    Other attributes like `Domain=`, `Path=`, etc. may come after the pair:
     *    `<cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly`
     * See `https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie`
     */
    bindingset[s, attribute]
    private predicate hasCookieAttribute(string s, string attribute) {
      s.regexpMatch("(?i).*;\\s*" + attribute + "\\b\\s*;?.*$")
    }
  }

  /**
   * A cookie set using `js-cookie` library (https://github.com/js-cookie/js-cookie).
   */
  class InsecureJsCookie extends CookieWrite {
    InsecureJsCookie() {
      this =
        [
          DataFlow::globalVarRef("Cookie"),
          DataFlow::globalVarRef("Cookie").getAMemberCall("noConflict"),
          DataFlow::moduleImport("js-cookie")
        ].getAMemberCall("set")
    }

    DataFlow::SourceNode getCookieOptionsArgument() {
      result = this.(DataFlow::CallNode).getAnArgument().getALocalSource()
    }

    DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getCookieOptionsArgument().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      getCookieFlagValue(secureFlag()).mayHaveBooleanValue(true)
    }

    override predicate isSensitive() { none() }

    override predicate isHttpOnly() { none() } // js-cookie is browser side library and doesn't support HttpOnly
  }
}
