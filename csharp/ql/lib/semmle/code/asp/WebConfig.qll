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

/**
 * A `Web.config` transformation file.
 */
class WebConfigReleaseTransformXml extends XmlFile {
  WebConfigReleaseTransformXml() { this.getName().matches("%Web.Release.config") }
}

/** A `<configuration>` tag in an ASP.NET configuration file. */
class ConfigurationXmlElement extends XmlElement {
  ConfigurationXmlElement() { this.getName().toLowerCase() = "configuration" }
}

/** A `<compilation>` tag in an ASP.NET configuration file. */
class CompilationXmlElement extends XmlElement {
  CompilationXmlElement() { this.getName().toLowerCase() = "compilation" }
}

/** A `<location>` tag in an ASP.NET configuration file. */
class LocationXmlElement extends XmlElement {
  LocationXmlElement() {
    this.getParent() instanceof ConfigurationXmlElement and
    this.getName().toLowerCase() = "location"
  }
}

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

/** A `<customErrors>` tag in an ASP.NET configuration file. */
class CustomErrorsXmlElement extends XmlElement {
  CustomErrorsXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "customerrors"
  }
}

/** A `<httpRuntime>` tag in an ASP.NET configuration file. */
class HttpRuntimeXmlElement extends XmlElement {
  HttpRuntimeXmlElement() {
    this.getParent() instanceof SystemWebXmlElement and
    this.getName().toLowerCase() = "httpruntime"
  }
}

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

  /**
   * Holds if `requireSSL` value is true.
   */
  predicate isRequireSsl() { this.getRequireSsl() = "true" }
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

  /**
   * Holds if there is any chance that `requireSSL` is set to `true` either globally or for Forms.
   */
  predicate isRequireSsl() {
    this.getRequireSsl() = "true"
    or
    not this.getRequireSsl() = "false" and // not set all, i.e. default
    exists(FormsElement forms | forms.getFile() = this.getFile() | forms.isRequireSsl())
  }
}

/** A `Transform` attribute in a Web.config transformation file. */
class TransformXmlAttribute extends XmlAttribute {
  TransformXmlAttribute() { this.getName().toLowerCase() = "transform" }

  /**
   * Gets the list of attribute removals in `Transform=RemoveAttributes(list)`.
   */
  string getRemoveAttributes() {
    result = this.getValue().regexpCapture("RemoveAttributes\\((.*)\\)", 1).splitAt(",")
  }
}
