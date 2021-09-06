/** Provides classes related to the namespace `System.Web.Http`. */

import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.Http` namespace. */
class SystemWebHttpNamespace extends Namespace {
  SystemWebHttpNamespace() {
    this.getParentNamespace() instanceof SystemWebNamespace and
    this.hasName("Http")
  }
}

/** A class in the `System.Web.Http` namespace. */
class SystemWebHttpClass extends Class {
  SystemWebHttpClass() { this.getNamespace() instanceof SystemWebHttpNamespace }
}

/** An interface in the `System.Web.Http` namespace. */
class SystemWebHttpInterface extends Interface {
  SystemWebHttpInterface() { this.getNamespace() instanceof SystemWebHttpNamespace }
}

/** An attribute whose type is in the `System.Web.Http` namespace. */
class SystemWebHttpAttribute extends Attribute {
  SystemWebHttpAttribute() { this.getType().getNamespace() instanceof SystemWebHttpNamespace }
}

/** An attribute whose type is `System.Web.Http.NonAction`. */
class SystemWebHttpNonActionAttribute extends SystemWebHttpAttribute {
  SystemWebHttpNonActionAttribute() { this.getType().hasName("NonActionAttribute") }
}

/** The `System.Web.Http.ApiController` class. */
class SystemWebHttpApiControllerClass extends SystemWebHttpClass {
  SystemWebHttpApiControllerClass() { this.hasName("ApiController") }
}

/** A subtype of `System.Web.Http.ApiController`. */
class ApiController extends Class {
  ApiController() { this.getABaseType*() instanceof SystemWebHttpApiControllerClass }

  /** Gets an action method for this controller. */
  Method getAnActionMethod() {
    result = this.getAMethod() and
    // Any public instance method.
    result.isPublic() and
    not result.isStatic() and
    not result.getAnAttribute() instanceof SystemWebHttpNonActionAttribute
  }
}

/**
 * Holds if this expression is a constant that evaluates to the name of an IIS server variable.
 */
predicate isServerVariable(Expr e) {
  exists(string s |
    s = e.getValue() and
    (
      s = "ALL_HTTP" or
      s = "ALL_RAW" or
      s = "APP_POOL_ID" or
      s = "APPL_MD_PATH" or
      s = "APPL_PHYSICAL_PATH" or
      s = "AUTH_PASSWORD" or
      s = "AUTH_TYPE" or
      s = "AUTH_USER" or
      s = "CACHE_URL" or
      s = "CERT_COOKIE" or
      s = "CERT_FLAGS" or
      s = "CERT_ISSUER" or
      s = "CERT_KEYSIZE" or
      s = "CERT_SECRETKEYSIZE" or
      s = "CERT_SERIALNUMBER" or
      s = "CERT_SERVER_ISSUER" or
      s = "CERT_SERVER_SUBJECT" or
      s = "CERT_SUBJECT" or
      s = "CONTENT_LENGTH" or
      s = "CONTENT_TYPE" or
      s = "GATEWAY_INTERFACE" or
      s.matches("HEADER\\_%") or // HEADER_<header_name>
      s.matches("HTTP\\_%") or // HTTP_<header_name>
      s = "HTTP_ACCEPT" or
      s = "HTTP_ACCEPT_ENCODING" or
      s = "HTTP_ACCEPT_LANGUAGE" or
      s = "HTTP_CONNECTION" or
      s = "HTTP_COOKIE" or
      s = "HTTP_HOST" or
      s = "HTTP_METHOD" or
      s = "HTTP_REFERER" or
      s = "HTTP_URL" or
      s = "HTTP_USER_AGENT" or
      s = "HTTP_VERSION" or
      s = "HTTPS" or
      s = "HTTPS_KEYSIZE" or
      s = "HTTPS_SECRETKEYSIZE" or
      s = "HTTPS_SERVER_ISSUER" or
      s = "HTTPS_SERVER_SUBJECT" or
      s = "INSTANCE_ID" or
      s = "INSTANCE_META_PATH" or
      s = "LOCAL_ADDR" or
      s = "LOGON_USER" or
      s = "PATH_INFO" or
      s = "PATH_TRANSLATED" or
      s = "QUERY_STRING" or
      s = "REMOTE_ADDR" or
      s = "REMOTE_HOST" or
      s = "REMOTE_PORT" or
      s = "REMOTE_USER" or
      s = "REQUEST_METHOD" or
      s = "SCRIPT_NAME" or
      s = "SCRIPT_TRANSLATED" or
      s = "SERVER_NAME" or
      s = "SERVER_PORT" or
      s = "SERVER_PORT_SECURE" or
      s = "SERVER_PROTOCOL" or
      s = "SERVER_SOFTWARE" or
      s = "SSI_EXEC_DISABLED" or
      s = "UNENCODED_URL" or
      s.matches("UNICODE\\_%") or // UNICODE_<server_variable_name>
      s = "UNMAPPED_REMOTE_USER" or
      s = "URL" or
      s = "URL_PATH_INFO"
    )
  )
}
