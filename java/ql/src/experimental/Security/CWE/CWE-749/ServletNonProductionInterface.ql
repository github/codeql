/**
 * @name Servlet Non Production Interface
 * @description Servlet non production interface is left behind and vulnerable to attacks.
 * @kind problem
 * @id java/servlet-non-production-interface
 * @tags security
 *       external/cwe/cwe-749
 */

import java
import NonProductionInterfaceLib
import semmle.code.xml.WebXML
import semmle.code.java.frameworks.Servlets

from WebServletMappingUrlPattern wsmup, WebServletClass wsc
where
  wsmup.getValue().regexpMatch("(?i).*test.*") and // The test interface is defined in `web.xml`
  wsc.getParent().getAChild("servlet-name").getTextValue() =
    wsmup.getParent().getAChild("servlet-name").getTextValue() and
  verifyClassWithPomWarExcludes(wsc.getClass())
select wsmup, "servlet non production interface is left behind and vulnerable to attacks"