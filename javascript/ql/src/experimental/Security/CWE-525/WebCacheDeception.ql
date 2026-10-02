/**
 * @name Web Cache Deception in Express
 * @description A caching system has been detected on the application and is vulnerable to web cache deception. By manipulating the URL it is possible to force the application to cache pages that are only accessible by an authenticated user. Once cached, these pages can be accessed by an unauthenticated user.
 * @kind problem
 * @problem.severity error
 * @security-severity 9
 * @precision medium
 * @id js/web-cache-deception-express
 * @tags javascript
 *       cwe-525
 *       bug
 */

import javascript
import WebCacheDeceptionLib

from WebCacheDeception::Sink httpHandleFuncCall
where httpHandleFuncCall.toString().matches("%*%")
select httpHandleFuncCall, httpHandleFuncCall + " is used as wildcard endpoint."
