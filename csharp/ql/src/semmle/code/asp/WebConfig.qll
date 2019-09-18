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
