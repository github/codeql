/**
 * @name Missing X-Frame-Options HTTP header
 * @description If the 'X-Frame-Options' setting is not provided, a malicious user may be able to
 *              overlay their own UI on top of the site by using an iframe.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/web/missing-x-frame-options
 * @tags security
 *       external/cwe/cwe-451
 *       external/cwe/cwe-829
 */

import csharp
import semmle.code.asp.WebConfig
import semmle.code.csharp.frameworks.system.Web

/**
 * Holds if the `Web.config` file `webConfig` adds an `X-Frame-Options` header.
 */
predicate hasWebConfigXFrameOptions(WebConfigXML webConfig) {
  // Looking for an entry in `webConfig` that looks like this:
  // ```xml
  // <system.webServer>
  //   <httpProtocol>
  //    <customHeaders>
  //      <add name="X-Frame-Options" value="SAMEORIGIN" />
  //    </customHeaders>
  //   </httpProtocol>
  // </system.webServer>
  // ```
  webConfig
      .getARootElement()
      .getAChild("system.webServer")
      .getAChild("httpProtocol")
      .getAChild("customHeaders")
      .getAChild("add")
      .getAttributeValue("name") = "X-Frame-Options"
}

/**
 * Holds if there exists a call to `AddHeader` or `AppendHeader` adding the `X-Frame-Options`
 * header.
 */
predicate hasCodeXFrameOptions() {
  exists(MethodCall call |
    call.getTarget() = any(SystemWebHttpResponseClass r).getAppendHeaderMethod() or
    call.getTarget() = any(SystemWebHttpResponseClass r).getAddHeaderMethod()
  |
    call.getArgumentForName("name").getValue() = "X-Frame-Options"
  )
}

from WebConfigXML webConfig
where
  not hasWebConfigXFrameOptions(webConfig) and
  not hasCodeXFrameOptions()
select webConfig, "Configuration file is missing the X-Frame-Options setting."
