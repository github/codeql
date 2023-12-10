/*
 * @name Web Cache Deception
 * @description A caching system has been detected on the application and is vulnerable to web cache deception on Gofiber. By manipulating the URL it is possible to force the application to cache pages that are only accessible by an authenticated user. Once cached, these pages can be accessed by an unauthenticated user.
 * @kind problem
 * @problem.severity error
 * @security-severity 9
 * @precision high
 * @id go/web-cache-deception-fiber
 * @tags security
 *       external/cwe/cwe-525
 */

import go

from DataFlow::CallNode httpHandleFuncCall, ImportSpec importSpec
where
  importSpec.getPath() = "github.com/gofiber/fiber/v2" and
  httpHandleFuncCall.getCall().getArgument(0).toString().matches("%/*%") and
  not httpHandleFuncCall.getCall().getArgument(0).toString().matches("%$%") and
  importSpec.getFile() = httpHandleFuncCall.getFile()
select httpHandleFuncCall.getCall().getArgument(0),
  "Wildcard Endpoint used with " + httpHandleFuncCall.getCall().getArgument(0)
