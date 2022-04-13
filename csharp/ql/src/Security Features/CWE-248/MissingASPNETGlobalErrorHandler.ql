/**
 * @name Missing global error handler
 * @description ASP.NET applications should not set the 'customError' mode to "off" without providing
 *              a global error handler, otherwise they may leak exception information.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cs/web/missing-global-error-handler
 * @tags security
 *       external/cwe/cwe-12
 *       external/cwe/cwe-248
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.XML

class Application_Error extends Method {
  Application_Error() {
    this.hasName("Application_Error") and
    this.getFile().getBaseName().toLowerCase() = "global.asax.cs" and
    this.hasNonEmptyBody()
  }
}

from CustomErrorsXmlElement customError
where
  // `<customErrors>` must be set to "off" to be dangerous
  customError.getAttributeValue("mode").toLowerCase() = "off" and
  // There must not be an error handler in global.asax
  not exists(Application_Error ae)
select customError,
  "'customErrors' mode set to off in Web.config, and no 'Application_Error' handler specified in the global.asax file."
