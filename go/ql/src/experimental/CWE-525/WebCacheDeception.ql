/*
 * @name Web Cache Deception
 * @description A caching system has been detected on the application and is vulnerable to web cache deception. By manipulating the URL it is possible to force the application to cache pages that are only accessible by an authenticated user. Once cached, these pages can be accessed by an unauthenticated user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id go/web-cache-deception
 * @tags security
 *       external/cwe/cwe-525
 */

import go

from
  DataFlow::CallNode httpHandleFuncCall, DataFlow::CallNode call, DataFlow::Node predecessor,
  Method get
where
  httpHandleFuncCall.getTarget().hasQualifiedName("net/http", "HandleFunc") and
  httpHandleFuncCall.getNumArgument() > 1 and
  httpHandleFuncCall.getArgument(0).getType().getUnderlyingType() = StringType and
  httpHandleFuncCall.getArgument(0).getStringValue().matches("%/\"") and
  // Trace the second argument's data flow to its predecessor
  predecessor = httpHandleFuncCall.getArgument(1).getAPredecessor() and
  // Find the corresponding expression for the predecessor
  get.hasQualifiedName("net/http", "Header", "Set") and
  call = get.getACall() and
  call.getArgument(0).getStringValue() = "\"Cache-Control\""
select httpHandleFuncCall.getArgument(0), call.getArgument(0)
