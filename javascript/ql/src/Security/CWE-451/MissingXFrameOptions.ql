/**
 * @name Missing X-Frame-Options HTTP header
 * @description If the 'X-Frame-Options' setting is not provided, a malicious user may be able to
 *              overlay their own UI on top of the site by using an iframe.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision low
 * @id js/missing-x-frame-options
 * @tags security
 *       external/cwe/cwe-451
 *       external/cwe/cwe-829
 */

import javascript
import semmle.javascript.frameworks.HTTP

from HTTP::ServerDefinition server
where not exists(server.getARouteHandler().getAResponseHeader("x-frame-options"))
select server, "This server never sets the 'X-Frame-Options' HTTP header."
