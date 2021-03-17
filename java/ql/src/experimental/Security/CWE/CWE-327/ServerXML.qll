/**
 * Provides classes for analyzing the Apache Tomcat `server.xml`.
 */

import java

/**
 * Holds if any `server.xml` files are included in this snapshot.
 */
predicate isServerXMLIncluded() { exists(ServerXMLFile serverXML) }

/**
 * The main server configuration file, typically called `server.xml` used by Apache Tomcat.
 */
class ServerXMLFile extends XMLFile {
  ServerXMLFile() {
    count(XMLElement e | e = this.getAChild()) = 1 and
    this.getAChild().getName() = "Server"
  }
}

/**
 * An XML element in a `ServerXMLFile`.
 */
class ServerXMLElement extends XMLElement {
  ServerXMLElement() { this.getFile() instanceof ServerXMLFile }

  /**
   * Gets the value for this element, with leading and trailing whitespace trimmed.
   */
  string getValue() { result = allCharactersString().trim() }
}

/**
 * The root `<Server>` element in a `server.xml` file.
 */
class Server extends ServerXMLElement {
  Server() { getName() = "Server" }
}

/**
 * The `<Service>` element in a `server.xml` file.
 */
class ServerService extends ServerXMLElement {
  ServerService() {
    getName() = "Service" and
    getAttributeValue("name").trim() = "Catalina" and
    getParent() instanceof Server
  }
}

/**
 * A `<Connector>` element in a `server.xml` file, nested under a `<Service>` element.
 */
class ServerConnector extends ServerXMLElement {
  ServerConnector() {
    getName() = "Connector" and
    getParent() instanceof ServerService
  }

  /** Holds if the scheme is `https` for an SSL Connector. */
  predicate isHttpsScheme() { getAttributeValue("scheme").trim() = "https" }

  /** Holds if the connector is used as a proxy. */
  predicate isProxy() { exists(XMLAttribute attr | attr = getAttribute("proxyName")) }

  /**
   * Holds if the `secure` attribute is set to `true` on an SSL Connector or a non SSL connector
   * that is receiving SSL data.
   */
  predicate isSecure() { getAttributeValue("secure").trim() = "true" }

  /** Holds if SSL traffic is enabled on a connector. */
  predicate isSSLEnabled() { getAttributeValue("SSLEnabled").trim() = "true" }

  /** Protocol of the connector, which can be JSSE (NIO/NIO2) or Native (APR). */
  string getProtocol() { result = getAttributeValue("protocol").trim() }

  /** TLS/SSL protocol configuration specific to JSEE connectors, default to TLS and deprecated in v8.5. */
  string getJseeSslProtocol() { result = getAttributeValue("sslProtocol").trim() }

  /** Enabled TLS/SSL protocol configuration specific to JSEE connectors, deprecated in v8.5. */
  string getEnabledJseeSslProtocols() { result = getAttributeValue("sslEnabledProtocols").trim() }

  /** Enabled TLS/SSL protocol configuration specific to APR connectors, deprecated in v8.5. */
  string getEnabledAprSslProtocols() { result = getAttributeValue("SSLProtocol").trim() }

  /** Cipher configuration specific to JSEE connectors, deprecated in v8.5. */
  string getJseeCiphers() { result = getAttributeValue("ciphers").trim() }

  /** Cipher configuration specific to APR connectors, deprecated in v8.5. */
  string getAprCiphers() { result = getAttributeValue("SSLCipherSuite").trim() }
}

/**
 * A `<SSLHostConfig>` element in a `server.xml` file, nested under a `<Connector>` element. It is a
 * new configuration in v8.5 and above that supports multiple TLS virtual hosts for a single connector
 * with each virtual host able to support multiple certificates.
 */
class ServerSSLHostConfig extends ServerXMLElement {
  ServerSSLHostConfig() {
    getName() = "SSLHostConfig" and
    getParent() instanceof ServerConnector
  }

  /**
   * Allowed TLS/SSL protocols, which can be `SSLv2Hello`, `SSLv3`, `TLSv1`, `TLSv1.1`, `TLSv1.2`,
   * `TLSv1.3`, or `all` and the default value is `all`. Each token in the list can be prefixed with
   * a plus sign ("+") or a minus sign ("-"). A plus sign adds the protocol, a minus sign removes it
   * from the current list.
   */
  string getProtocols() { result = getAttributeValue("protocols").trim() }

  /**
   * The ciphers to enable using the OpenSSL syntax. Alternatively, a comma separated list of ciphers
   * using the standard OpenSSL cipher names or the standard JSSE cipher names may be used. The default
   * value is `HIGH:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!kRSA`.
   */
  string getCiphers() { result = getAttributeValue("ciphers").trim() }
}
