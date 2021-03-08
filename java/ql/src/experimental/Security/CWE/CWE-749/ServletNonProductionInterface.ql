/**
 * @name Servlet Non Production Interface
 * @description Servlet non production interface is left behind and vulnerable to attacks.
 * @kind problem
 * @id java/servlet-non-production-interface
 * @tags security
 *       external/cwe/cwe-749
 */

import java
import semmle.code.xml.WebXML
import semmle.code.java.frameworks.Servlets

from WebServletMappingUrlPattern wsmup
where wsmup.getValue().regexpMatch("(?i).*test.*") // The test interface is defined in `web.xml`
select wsmup, "servlet non production interface is left behind and vulnerable to attacks"
