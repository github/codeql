/**
 * Provides classes and predicates related to ASP.NET Web.config files.
 */

import csharp

/**
 * A `Web.config` file.
 */
class WebConfigXml extends XmlFile {
  WebConfigXml() { this.getName().matches("%Web.config") }
}

/** DEPRECATED: Alias for WebConfigXml */
deprecated class WebConfigXML = WebConfigXml;

/** A `<configuration>` tag in an ASP.NET configuration file. */
class ConfigurationXmlElement extends XmlElement {
  ConfigurationXmlElement() { this.getName().toLowerCase() = "configuration" }
}

/** DEPRECATED: Alias for ConfigurationXmlElement */
deprecated class ConfigurationXMLElement = ConfigurationXmlElement;

/** A `<location>` tag in an ASP.NET configuration file. */
class LocationXmlElement extends XmlElement {
  LocationXmlElement() {
    this.getParent() instanceof ConfigurationXmlElement and
    this.getName().toLowerCase() = "location"
  }
}

/** DEPRECATED: Alias for LocationXmlElement */
deprecated class LocationXMLElement = LocationXmlElement;

/** A `<system.web>` tag in an ASP.NET configuration file. */
class SystemWebXmlElement extends XmlElement {
  SystemWebXmlElement() {
    (
      this.getParent() instanceof ConfigurationXmlElement
      or
      this.getParent() instanceof LocationXmlElement
    ) and
    this.getName().toLowerCase() = "system.web"
  }
}

/** DEPRECATED: Alias for SystemWebXmlElement */
deprecated class SystemWebXMLElement = SystemWebXmlElement;

/** A `<system.webServer>` tag in an ASP.NET configuration file. */
class SystemWebServerXmlElement extends XmlElement {
  SystemWebServerXmlElement() {
    (
      this.getParent() instanceof ConfigurationXmlElement
      or
      this.getParent() instanceof LocationXmlElement
    ) and
    this.getName().toLowerCase() = "system.webserver"
  }
}

/** DEPRECATED: Alias for SystemWebServerXmlElement */
deprecated class SystemWebServerXMLElement = SystemWebServerXmlElement;

/** A `<customErrors>` tag in an ASP.NET configuration file. */
class CustomErrorsXmlElement extends XmlElement {
  CustomErrorsXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "customerrors"
  }
}

/** DEPRECATED: Alias for CustomErrorsXmlElement */
deprecated class CustomErrorsXMLElement = CustomErrorsXmlElement;

/** A `<httpRuntime>` tag in an ASP.NET configuration file. */
class HttpRuntimeXmlElement extends XmlElement {
  HttpRuntimeXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "httpruntime"
  }
}

/** DEPRECATED: Alias for HttpRuntimeXmlElement */
deprecated class HttpRuntimeXMLElement = HttpRuntimeXmlElement;

/** A `<forms>` tag under `<system.web><authentication>` in an ASP.NET configuration file. */
class FormsElement extends XmlElement {
  FormsElement() {
    this = any(SystemWebXmlElement sw).getAChild("authentication").getAChild("forms")
  }

  /**
   * Gets attribute's `requireSSL` value.
   */
  string getRequireSsl() {
    result = this.getAttribute("requireSSL").getValue().trim().toLowerCase()
  }

  /** DEPRECATED: Alias for getRequireSsl */
  deprecated string getRequireSSL() { result = this.getRequireSsl() }

  /**
   * Holds if `requireSSL` value is true.
   */
  predicate isRequireSsl() { this.getRequireSsl() = "true" }

  /** DEPRECATED: Alias for isRequireSsl */
  deprecated predicate isRequireSSL() { this.isRequireSsl() }
}

/** A `<httpCookies>` tag in an ASP.NET configuration file. */
class HttpCookiesElement extends XmlElement {
  HttpCookiesElement() { this = any(SystemWebXmlElement sw).getAChild("httpCookies") }

  /**
   * Gets attribute's `httpOnlyCookies` value.
   */
  string getHttpOnlyCookies() {
    result = this.getAttribute("httpOnlyCookies").getValue().trim().toLowerCase()
  }

  /**
   * Holds if there is any chance that `httpOnlyCookies` is set to `true`.
   */
  predicate isHttpOnlyCookies() { this.getHttpOnlyCookies() = "true" }

  /**
   * Gets attribute's `requireSSL` value.
   */
  string getRequireSsl() {
    result = this.getAttribute("requireSSL").getValue().trim().toLowerCase()
  }

  /** DEPRECATED: Alias for getRequireSsl */
  deprecated string getRequireSSL() { result = this.getRequireSsl() }

  /**
   * Holds if there is any chance that `requireSSL` is set to `true` either globally or for Forms.
   */
  predicate isRequireSsl() {
    this.getRequireSsl() = "true"
    or
    not this.getRequireSsl() = "false" and // not set all, i.e. default
    exists(FormsElement forms | forms.getFile() = this.getFile() | forms.isRequireSsl())
  }

  /** DEPRECATED: Alias for isRequireSsl */
  deprecated predicate isRequireSSL() { this.isRequireSsl() }
}
