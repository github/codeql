/**
 * Provides definitions related to the namespace `Microsoft.Owin`.
 *
 * OWIN defines a standard interface between .NET web servers and web applications.
 */

import csharp
import semmle.code.csharp.frameworks.Microsoft

/** The `Microsoft.Owin` namespace. */
class MicrosoftOwinNamespace extends Namespace {
  MicrosoftOwinNamespace() {
    this.getParentNamespace() instanceof MicrosoftNamespace and
    this.hasName("Owin")
  }
}

/** The `Microsoft.Owin.IOwinRequest` class. */
class MicrosoftOwinIOwinRequestClass extends Class {
  MicrosoftOwinIOwinRequestClass() {
    this.getNamespace() instanceof MicrosoftOwinNamespace and
    this.hasName("IOwinRequest")
  }

  /** Gets the `Accept` property. */
  Property getAcceptProperty() {
    result = this.getAProperty() and
    result.hasName("Accept")
  }

  /** Gets the `Body` property. */
  Property getBodyProperty() {
    result = this.getAProperty() and
    result.hasName("Body")
  }

  /** Gets the `CacheControl` property. */
  Property getCacheControlProperty() {
    result = this.getAProperty() and
    result.hasName("CacheControl")
  }

  /** Gets the `ContentType` property. */
  Property getContentTypeProperty() {
    result = this.getAProperty() and
    result.hasName("ContentType")
  }

  /** Gets the `Context` property. */
  Property getContextProperty() {
    result = this.getAProperty() and
    result.hasName("Context")
  }

  /** Gets the `Cookies` property. */
  Property getCookiesProperty() {
    result = this.getAProperty() and
    result.hasName("Cookies")
  }

  /** Gets the `Headers` property. */
  Property getHeadersProperty() {
    result = this.getAProperty() and
    result.hasName("Headers")
  }

  /** Gets the `Host` property. */
  Property getHostProperty() {
    result = this.getAProperty() and
    result.hasName("Host")
  }

  /** Gets the `MediaType` property. */
  Property getMediaTypeProperty() {
    result = this.getAProperty() and
    result.hasName("MediaType")
  }

  /** Gets the `Method` property. */
  Property getMethodProperty() {
    result = this.getAProperty() and
    result.hasName("Method")
  }

  /** Gets the `Path` property. */
  Property getPathProperty() {
    result = this.getAProperty() and
    result.hasName("Path")
  }

  /** Gets the `PathBase` property. */
  Property getPathBaseProperty() {
    result = this.getAProperty() and
    result.hasName("PathBase")
  }

  /** Gets the `Query` property. */
  Property getQueryProperty() {
    result = this.getAProperty() and
    result.hasName("Query")
  }

  /** Gets the `QueryString` property. */
  Property getQueryStringProperty() {
    result = this.getAProperty() and
    result.hasName("QueryString")
  }

  /** Gets the `RemoteIpAddress` property. */
  Property getRemoteIpAddressProperty() {
    result = this.getAProperty() and
    result.hasName("RemoteIpAddress")
  }

  /** Gets the `Scheme` property. */
  Property getSchemeProperty() {
    result = this.getAProperty() and
    result.hasName("Scheme")
  }

  /** Gets the `Uri` property. */
  Property getUriProperty() {
    result = this.getAProperty() and
    result.hasName("Uri")
  }
}

/** A `Microsoft.Owin.*String` class. */
class MicrosoftOwinString extends Class {
  MicrosoftOwinString() {
    this.getNamespace() instanceof MicrosoftOwinNamespace and
    this.getName().matches("%String")
  }

  /** Gets the `Value` property. */
  Property getValueProperty() {
    result = this.getAProperty() and
    result.hasName("Value")
  }
}
