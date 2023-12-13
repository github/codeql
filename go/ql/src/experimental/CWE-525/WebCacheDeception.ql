/*
 * @name Web Cache Deception
 * @description A caching system has been detected on the application and is vulnerable to web cache deception on Gofiber. By manipulating the URL it is possible to force the application to cache pages that are only accessible by an authenticated user. Once cached, these pages can be accessed by an unauthenticated user.
 * @kind problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id go/web-cache-deception
 * @tags security
 *       external/cwe/cwe-525
 */

import go
import WebCacheDeceptionLib
import WebCacheDeception::Flow::PathGraph

from WebCacheDeception::Sink httpHandleFuncCall
select httpHandleFuncCall, "$@ is used as wildcard endpoint.", httpHandleFuncCall.getNode(),
  "Web Cache Deception"
