/** Provides definitions related to the namespace `System.Net`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Net` namespace. */
class SystemNetNamespace extends Namespace {
  SystemNetNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Net")
  }
}

/** A class in the `System.Net` namespace. */
class SystemNetClass extends Class {
  SystemNetClass() { this.getNamespace() instanceof SystemNetNamespace }
}

/** The `System.Net.WebUtility` class. */
class SystemNetWebUtility extends SystemNetClass {
  SystemNetWebUtility() { this.hasName("WebUtility") }

  /** Gets an `HtmlEncode` method. */
  Method getAnHtmlEncodeMethod() { result = this.getAMethod("HtmlEncode") }

  /** Gets an `UrlEncode` method. */
  Method getAnUrlEncodeMethod() { result = this.getAMethod("UrlEncode") }
}

/** The `System.Net.HttpListenerResponse` class. */
class SystemNetHttpListenerResponseClass extends SystemNetClass {
  SystemNetHttpListenerResponseClass() { this.hasName("HttpListenerResponse") }

  /** Gets the `OutputStream` Property. */
  Property getOutputStreamProperty() { result = this.getProperty("OutputStream") }
}

/** The `System.Net.HttpListenerResponse` class. */
class SystemNetHttpListenerRequestClass extends SystemNetClass {
  SystemNetHttpListenerRequestClass() { this.hasName("HttpListenerRequest") }
}

/** The `System.Net.Dns` class. */
class SystemNetDnsClass extends SystemNetClass {
  SystemNetDnsClass() { this.hasName("Dns") }

  /** Gets the `GetHostByAddress` method. */
  Method getGetHostByAddressMethod() { result = this.getAMethod("GetHostByAddress") }
}

/** The `System.Net.IPHostEntry` class. */
class SystemNetIPHostEntryClass extends SystemNetClass {
  SystemNetIPHostEntryClass() { this.hasName("IPHostEntry") }

  /** Gets the `HostName` property. */
  Property getHostNameProperty() { result = this.getProperty("HostName") }

  /** Gets the `Aliases` property. */
  Property getAliasesProperty() { result = this.getProperty("Aliases") }
}

/** The `System.Net.Cookie` class. */
class SystemNetCookieClass extends SystemNetClass {
  SystemNetCookieClass() { this.hasName("Cookie") }

  /** Gets the `Value` property. */
  Property getValueProperty() { result = this.getProperty("Value") }
}
