/**
 * @name Directories and files exposure
 * @description A directory listing provides an attacker with the complete index of all the resources located inside of the complete web directory, which could yield files containing sensitive information like source code and credentials to the attacker.
 * @kind problem
 * @id java/server-directory-listing
 * @tags security
 *       external/cwe-548
 */

import java
import semmle.code.xml.WebXML

/**
 * The default `<servlet-class>` element in a `web.xml` file.
 */
private class DefaultTomcatServlet extends WebServletClass {
  DefaultTomcatServlet() {
    this.getTextValue() = "org.apache.catalina.servlets.DefaultServlet" //Default servlet of Tomcat and other servlet containers derived from Tomcat like Glassfish
  }
}

/**
 * The `<init-param>` element in a `web.xml` file, nested under a `<servlet>` element controlling directory listing.
 */
class DirectoryListingInitParam extends WebXMLElement {
  DirectoryListingInitParam() {
    getName() = "init-param" and
    getAChild("param-name").getTextValue() = "listings" and
    exists(WebServlet servlet |
      getParent() = servlet and servlet.getAChild("servlet-class") instanceof DefaultTomcatServlet
    )
  }

  /**
   * Check the `<param-value>` element (true - enabled, false - disabled)
   */
  predicate isListingEnabled() { getAChild("param-value").getTextValue().toLowerCase() = "true" }
}

from DirectoryListingInitParam initp
where initp.isListingEnabled()
select initp, "Directory listing should be disabled to mitigate filename and path disclosure"
