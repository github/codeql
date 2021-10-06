/**
 * @name 'HttpOnly' attribute is not set to true
 * @description Omitting the 'HttpOnly' attribute for security sensitive cookie data allows
 *              malicious JavaScript to steal it in case of XSS vulnerabilities. Always set
 *              'HttpOnly' to 'true' for authentication related cookies to make them
 *              inaccessible from JavaScript.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/cookie-httponly-not-set
 * @tags security
 *       external/cwe/cwe-1004
 */

import javascript

from DataFlow::Node node
where
  // TODO: Give all descriptions, qlhelp, qldocs, an overhaul. Consider precisions, severity, cwes.
  exists(CookieWrites::CookieWrite cookie | cookie = node |
    cookie.isSensitive() and not cookie.isHttpOnly()
  )
select node, "Cookie attribute 'HttpOnly' is not set to true for this sensitive cookie."
