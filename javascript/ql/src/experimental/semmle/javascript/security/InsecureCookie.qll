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
}
