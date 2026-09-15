/**
 * @name Missing clickjacking protection
 * @description If neither the 'X-Frame-Options' header nor a Content Security Policy
 *              'frame-ancestors' directive is provided, a malicious user may be able to overlay
 *              their own UI on top of the site by using an iframe.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/web/missing-x-frame-options
 * @tags security
 *       external/cwe/cwe-451
 *       external/cwe/cwe-829
 */

import csharp
import semmle.code.asp.WebConfig
import Security_Features.MissingXFrameOptionsLib

XmlElement getAWebConfigRoot(WebConfigXml webConfig) {
  result = webConfig.getARootElement()
  or
  result = webConfig.getARootElement().getAChild("location") and
  (
    not result.hasAttribute("path") // equivalent to path="."
    or
    result.getAttributeValue("path") = ["", "."]
  )
}

/**
 * Holds if the `Web.config` file `webConfig` adds an `X-Frame-Options` header or a
 * `Content-Security-Policy` header containing a `frame-ancestors` directive.
 */
predicate hasWebConfigClickjackingProtection(WebConfigXml webConfig) {
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
  // This can also be in a `location`
  exists(XmlElement add, string name |
    add =
      getAWebConfigRoot(webConfig)
          .getAChild("system.webServer")
          .getAChild("httpProtocol")
          .getAChild("customHeaders")
          .getAChild("add") and
    name = add.getAttributeValue("name") and
    (
      isXFrameOptionsHeaderName(name)
      or
      isContentSecurityPolicyHeaderName(name) and
      containsFrameAncestorsDirective(add.getAttributeValue("value"))
    )
  )
}

/**
 * Holds if code configures a clickjacking protection response header.
 */
predicate hasCodeClickjackingProtection() { exists(getAClickjackingHeaderWrite()) }

from WebConfigXml webConfig
where
  not hasWebConfigClickjackingProtection(webConfig) and
  not hasCodeClickjackingProtection()
select webConfig, "Configuration file is missing clickjacking protection."
