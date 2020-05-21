/**
 * @id java/insecure-hsts
 * @name Unprotected transport of credentials without HTTP Strict Transport Security (HSTS)
 * @description HSTS is a web security policy mechanism that helps to protect websites against man-in-the-middle attacks such as protocol downgrade attacks and cookie hijacking.  HSTS is specified in RFC 6797 and is supported by all major browsers and web servers. Missing or incorrect configuration allows unprotected transport of credentials.
 *     This query covers three scenarios of insecure configuration with Tomcat servlet container:
 *     1. HttpHeaderSecurityFilter not configured
 *     2. Filter is configured but is explicitly disabled
 *     3. Filter is not mapped to all resources
 * @kind problem
 * @tags security
 *       external/cwe-523
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
 * A `<filter>` element in a `web.xml` file configured for HSTS.
 */
private class HstsFilter extends WebFilter {
  HstsFilter() {
    this.getAChild("filter-class").getTextValue() =
      "org.apache.catalina.filters.HttpHeaderSecurityFilter" //Tomcat HSTS filter
  }

  string getFilterName() { result = this.getAChild("filter-name").getTextValue() }
  //string getFilterClass() { result = this.getAChild("filter-class").getTextValue() }
}

/**
 * A `<init-param>` element in a `web.xml` file, nested under a `<filter>` element.
 */
class HstsFilterInitParam extends WebXMLElement {
  HstsFilterInitParam() { getName() = "init-param" and getParent() instanceof HstsFilter }

  /**
   * Gets the `<param-name>` element of this `<init-param>` for the `<filter>`.
   */
  string getParamName() { result = this.getAChild("param-name").getTextValue() }

  /**
   * Gets the `<param-value>` element of this `<init-param>` for the `<filter>`.
   */
  string getParamValue() { result = this.getAChild("param-value").getTextValue() }
}

/**
 * A `<filter-mapping>` element in a `web.xml` file.
 */
class WebFilterMapping extends WebXMLElement {
  WebFilterMapping() { getName() = "filter-mapping" }

  /**
   * Gets the `<filter-name>` element of this `<filter-mapping>`.
   */
  string getFilterName() { result = getAChild("filter-name").getTextValue() }

  /**
   * Gets the `<url-pattern>` element of this `<filter-mapping>`.
   */
  string getUrlPattern() { result = getAChild("url-pattern").getTextValue() }
}

from WebXMLFile webXml
where
  not exists(HstsFilter filter) and
  exists(DefaultTomcatServlet tomcat) //Tomcat servlet container without HSTS filter configured
  or
  exists(HstsFilter filter, WebFilterMapping filterMapping |
    filter.getFilterName() = filterMapping.getFilterName() and
    (
      exists(HstsFilterInitParam initparam |
        initparam.getParamName() = "hstsEnabled" and initparam.getParamValue() = "false" //hstsEnabled is set to false for the HSTS filter (default value is true)
      )
      or
      filterMapping.getUrlPattern() != "/*" //Filter is not applied to all URLs
    )
  )
select webXml,
  "HSTS shall be enabled in web.xml to help mitigate MITM and protocol downgrade attacks"
