/**
 * Provides classes and predicates related to ASP.NET Web.config files.
 */

import csharp

/**
 * A `Web.config` file.
 */
class WebConfigXML extends XMLFile {
  WebConfigXML() { getName().matches("%Web.config") }
}

/** A `<configuration>` tag in an ASP.NET configuration file. */
class ConfigurationXMLElement extends XMLElement {
  ConfigurationXMLElement() { this.getName().toLowerCase() = "configuration" }
}

/** A `<location>` tag in an ASP.NET configuration file. */
class LocationXMLElement extends XMLElement {
  LocationXMLElement() {
    this.getParent() instanceof ConfigurationXMLElement and
    this.getName().toLowerCase() = "location"
  }
}

/** A `<system.web>` tag in an ASP.NET configuration file. */
class SystemWebXMLElement extends XMLElement {
  SystemWebXMLElement() {
    (
      this.getParent() instanceof ConfigurationXMLElement
      or
      this.getParent() instanceof LocationXMLElement
    ) and
    this.getName().toLowerCase() = "system.web"
  }
}

/** A `<system.webServer>` tag in an ASP.NET configuration file. */
class SystemWebServerXMLElement extends XMLElement {
  SystemWebServerXMLElement() {
    (
      this.getParent() instanceof ConfigurationXMLElement
      or
      this.getParent() instanceof LocationXMLElement
    ) and
    this.getName().toLowerCase() = "system.webserver"
  }
}

/** A `<customErrors>` tag in an ASP.NET configuration file. */
class CustomErrorsXMLElement extends XMLElement {
  CustomErrorsXMLElement() {
    this.getParent() instanceof SystemWebXMLElement and
    this.getName().toLowerCase() = "customerrors"
  }
}

/** A `<httpRuntime>` tag in an ASP.NET configuration file. */
class HttpRuntimeXMLElement extends XMLElement {
  HttpRuntimeXMLElement() {
    this.getParent() instanceof SystemWebXMLElement and
    this.getName().toLowerCase() = "httpruntime"
  }
}

/** A `<forms>` tag under `<system.web><authentication>` in an ASP.NET configuration file. */
class FormsElement extends XMLElement {
  FormsElement() {
    this = any(SystemWebXMLElement sw).getAChild("authentication").getAChild("forms")
  }

  /**
   * Gets attribute's `requireSSL` value.
   */
  string getRequireSSL() { result = getAttribute("requireSSL").getValue().trim().toLowerCase() }

  /**
   * Holds if `requireSSL` value is true.
   */
  predicate isRequireSSL() { getRequireSSL() = "true" }
}

/** A `<httpCookies>` tag in an ASP.NET configuration file. */
class HttpCookiesElement extends XMLElement {
  HttpCookiesElement() { this = any(SystemWebXMLElement sw).getAChild("httpCookies") }

  /**
   * Gets attribute's `httpOnlyCookies` value.
   */
  string getHttpOnlyCookies() {
    result = getAttribute("httpOnlyCookies").getValue().trim().toLowerCase()
  }

  /**
   * Holds if there is any chance that `httpOnlyCookies` is set to `true`.
   */
  predicate isHttpOnlyCookies() { getHttpOnlyCookies() = "true" }

  /**
   * Gets attribute's `requireSSL` value.
   */
  string getRequireSSL() { result = getAttribute("requireSSL").getValue().trim().toLowerCase() }

  /**
   * Holds if there is any chance that `requireSSL` is set to `true` either globally or for Forms.
   */
  predicate isRequireSSL() {
    getRequireSSL() = "true"
    or
    not getRequireSSL() = "false" and // not set all, i.e. default
    exists(FormsElement forms | forms.getFile() = getFile() | forms.isRequireSSL())
  }
}
