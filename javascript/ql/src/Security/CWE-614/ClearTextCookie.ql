/**
 * @name Clear text transmission of sensitive cookie
 * @description Sending sensitive information in a cookie without requring SSL encryption
 *              can expose the cookie to an attacker.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.0
 * @precision high
 * @id js/clear-text-cookie
 * @tags security
 *       external/cwe/cwe-614
 *       external/cwe/cwe-311
 *       external/cwe/cwe-312
 *       external/cwe/cwe-319
 */

import javascript

from CookieWrites::CookieWrite cookie
where cookie.isSensitive() and not cookie.isSecure()
select cookie, "Sensitive cookie sent without enforcing SSL encryption."
