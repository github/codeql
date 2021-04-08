/**
 * @name Failure to set secure cookies
 * @description Insecure cookies may be sent in cleartext, which makes them vulnerable to
 *              interception.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/insecure-cookie
 * @tags security
 *       external/cwe/cwe-614
 */

import javascript
import InsecureCookie::Cookie

from Cookie cookie
where not cookie.isSecure()
select cookie, "Cookie is added to response without the 'secure' flag being set to true"
