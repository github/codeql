/** Provides definitions related to the namespace `System.Web`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.collections.Specialized

/** The `System.Web` namespace. */
class SystemWebNamespace extends Namespace {
  SystemWebNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Web")
  }
}

/** A class in the `System.Web` namespace. */
class SystemWebClass extends Class {
  SystemWebClass() { this.getNamespace() instanceof SystemWebNamespace }
}

/** An interface in the `System.Web` namespace. */
class SystemWebInterface extends Interface {
  SystemWebInterface() { this.getNamespace() instanceof SystemWebNamespace }
}

/** The `System.Web.HttpRequest` class. */
class SystemWebHttpRequestClass extends SystemWebClass {
  SystemWebHttpRequestClass() { this.hasName("HttpRequest") }

  /** Gets the `NameValueCollection QueryString` property. */
  IndexerProperty getQueryStringProperty() {
    result.getDeclaringType() = this and
    result.hasName("QueryString") and
    result.getType() instanceof SystemCollectionsSpecializedNameValueCollectionClass
  }

  /** Gets the `NameValueCollection Headers` property. */
  IndexerProperty getHeadersProperty() {
    result.getDeclaringType() = this and
    result.hasName("Headers") and
    result.getType() instanceof SystemCollectionsSpecializedNameValueCollectionClass
  }

  /** Gets the  `string RawUrl` property. */
  Property getRawUrlProperty() {
    result.getDeclaringType() = this and
    result.hasName("RawUrl") and
    result.getType() instanceof StringType
  }

  /** Gets the `UnvalidatedRequestValues Unvalidated` property. */
  Property getUnvalidatedProperty() {
    result.getDeclaringType() = this and
    result.hasName("Unvalidated") and
    result.getType() instanceof SystemWebUnvalidatedRequestValues
  }

  /** Gets the  `Uri Url` property. */
  Property getUrlProperty() {
    result.getDeclaringType() = this and
    result.hasName("Url") and
    result.getType() instanceof SystemUriClass
  }
}

/** The `System.Web.UnvalidatedRequestValues` class. */
class SystemWebUnvalidatedRequestValues extends SystemWebClass {
  SystemWebUnvalidatedRequestValues() { this.hasName("UnvalidatedRequestValues") }
}

/** The `System.Web.UnvalidatedRequestValuesBase` class. */
class SystemWebUnvalidatedRequestValuesBase extends SystemWebClass {
  SystemWebUnvalidatedRequestValuesBase() { this.hasName("UnvalidatedRequestValuesBase") }
}

/** The `System.Web.HttpRequestMessage` class. */
class SystemWebHttpRequestMessageClass extends SystemWebClass {
  SystemWebHttpRequestMessageClass() { this.hasName("HttpRequestMessage") }
}

/** The `System.Web.HttpRequestBase` class. */
class SystemWebHttpRequestBaseClass extends SystemWebClass {
  SystemWebHttpRequestBaseClass() { this.hasName("HttpRequestBase") }
}

/** The `System.Web.HttpResponse` class. */
class SystemWebHttpResponseClass extends SystemWebClass {
  SystemWebHttpResponseClass() { this.hasName("HttpResponse") }

  /** Gets the `AddHeader` method. */
  Method getAddHeaderMethod() { result = this.getAMethod("AddHeader") }

  /** Gets the `AppendHeader` method. */
  Method getAppendHeaderMethod() { result = this.getAMethod("AppendHeader") }

  /** Gets a `Write` method. */
  Method getAWriteMethod() {
    result.getDeclaringType() = this and
    result.hasName("Write")
  }

  /** Gets a `WriteFile` method. */
  Method getAWriteFileMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteFile")
  }

  /** Gets a `BinaryWrite` method. */
  Method getABinaryWriteMethod() {
    result.getDeclaringType() = this and
    result.hasName("BinaryWrite")
  }

  /** Gets a `TransmitFile` method. */
  Method getATransmitFileMethod() {
    result.getDeclaringType() = this and
    result.hasName("TransmitFile")
  }

  /** Gets the `Redirect` method. */
  Method getRedirectMethod() {
    result.getDeclaringType() = this and
    result.hasName("Redirect")
  }
}

/** The `System.Web.HttpResponseBase` class. */
class SystemWebHttpResponseBaseClass extends SystemWebClass {
  SystemWebHttpResponseBaseClass() { this.hasName("HttpResponseBase") }

  /** Gets a `Write` method. */
  Method getAWriteMethod() {
    result.getDeclaringType() = this and
    result.hasName("Write")
  }

  /** Gets a `WriteFile` method. */
  Method getAWriteFileMethod() {
    result.getDeclaringType() = this and
    result.hasName("WriteFile")
  }

  /** Gets a `BinaryWrite` method. */
  Method getABinaryWriteMethod() {
    result.getDeclaringType() = this and
    result.hasName("BinaryWrite")
  }

  /** Gets a `TransmitFile` method. */
  Method getATransmitFileMethod() {
    result.getDeclaringType() = this and
    result.hasName("TransmitFile")
  }
}

/** A subtype of `System.Web.HttpApplication. */
class WebApplication extends Class {
  WebApplication() { this.getABaseType*().(SystemWebClass).hasName("HttpApplication") }

  /** Gets the `Application_Start` Method. */
  Method getApplication_StartMethod() { result = this.getAMethod("Application_Start") }
}

/** The `System.Web.HttpServerUtility` class. */
class SystemWebHttpServerUtility extends SystemWebClass {
  SystemWebHttpServerUtility() { this.hasName("HttpServerUtility") }

  /** Gets an `HtmlEncode` method. */
  Method getAnHtmlEncodeMethod() { result = this.getAMethod("HtmlEncode") }

  /** Gets the `Transfer` method. */
  Method getTransferMethod() { result = this.getAMethod("Transfer") }

  /** Gets an `UrlEncode` method. */
  Method getAnUrlEncodeMethod() { result = this.getAMethod("UrlEncode") }
}

/** The `System.Web.HttpUtility` class. */
class SystemWebHttpUtility extends SystemWebClass {
  SystemWebHttpUtility() { this.hasName("HttpUtility") }

  /** Gets an `HtmlAttributeEncode` method. */
  Method getAnHtmlAttributeEncodeMethod() { result = this.getAMethod("HtmlAttributeEncode") }

  /** Gets an `HtmlEncode` method. */
  Method getAnHtmlEncodeMethod() { result = this.getAMethod("HtmlEncode") }

  /** Gets a `JavaScriptStringEncode` method. */
  Method getAJavaScriptStringEncodeMethod() { result = this.getAMethod("JavaScriptStringEncode") }

  /** Gets an `UrlEncode` method. */
  Method getAnUrlEncodeMethod() { result = this.getAMethod("UrlEncode") }
}

/** The `System.Web.HttpCookie` class. */
class SystemWebHttpCookie extends SystemWebClass {
  SystemWebHttpCookie() { this.hasName("HttpCookie") }

  /** Gets the `Value` property. */
  Property getValueProperty() { result = this.getProperty("Value") }

  /** Gets the `Values` property. */
  IndexerProperty getValuesProperty() { result = this.getProperty("Values") }

  /** Gets the `Secure` property. */
  Property getSecureProperty() { result = this.getProperty("Secure") }
}

/** The `System.Web.IHtmlString` class. */
class SystemWebIHtmlString extends SystemWebInterface {
  SystemWebIHtmlString() { this.hasName("IHtmlString") }

  /** Gets the `ToHtmlString` Method. */
  Method getToHtmlStringMethod() { result = this.getAMethod("ToHtmlString") }
}

/** The `System.Web.HtmlString` class. */
class SystemWebHtmlString extends SystemWebClass {
  SystemWebHtmlString() { this.hasName("HtmlString") }
}
