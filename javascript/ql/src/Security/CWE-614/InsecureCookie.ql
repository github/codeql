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

from DataFlow::Node node
where exists(CookieWrites::CookieWrite cookie | cookie = node | not cookie.isSecure())
select node, "Cookie is added to response without the 'secure' flag being set to true"
