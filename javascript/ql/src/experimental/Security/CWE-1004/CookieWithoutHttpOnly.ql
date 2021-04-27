/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive data allows
 *              malicious JavaScript to steal it in case of XSS vulnerability. Always set
 *              'HttpOnly' to 'true' to authentication related cookie to make it
 *              not accessible by JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/cookie-httponly-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import javascript
import semmle.javascript.security.InsecureCookie::Cookie

from Cookie cookie
where cookie.isAuthNotHttpOnly()
select cookie, "Cookie attribute 'HttpOnly' is not set to true."
