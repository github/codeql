/*
 * @name Web Cache Deception
 * @description A caching system has been detected on the application and is vulnerable to web cache deception. By manipulating the URL it is possible to force the application to cache pages that are only accessible by an authenticated user. Once cached, these pages can be accessed by an unauthenticated user.
 * @kind problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id go/web-cache-deception
 * @tags security
 *       external/cwe/cwe-525
 */

import go

from
  DataFlow::CallNode httpHandleFuncCall, DataFlow::ReadNode rn, Http::HeaderWrite::Range hw,
  DeclaredFunction f
where
  httpHandleFuncCall.getTarget().hasQualifiedName("net/http", "HandleFunc") and
  httpHandleFuncCall.getArgument(0).getStringValue().matches("%/") and
  httpHandleFuncCall.getArgument(1) = rn and
  rn.reads(f) and
  f.getParameter(0) = hw.getResponseWriter() and
  hw.getHeaderName() = "cache-control"
select httpHandleFuncCall.getArgument(0),
  "Wildcard Endpoint used with " + httpHandleFuncCall.getArgument(0) + " and '" + hw.getHeaderName()
    + "' Header is used"
