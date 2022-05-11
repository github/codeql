/** Provides definitions related to the namespace `System.Net`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.Net.WebUtility`. */
private class SystemNetWebUtilityFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Net;WebUtility;false;HtmlEncode;(System.String);;Argument[0];ReturnValue;taint",
        "System.Net;WebUtility;false;HtmlEncode;(System.String,System.IO.TextWriter);;Argument[0];ReturnValue;taint",
        "System.Net;WebUtility;false;UrlEncode;(System.String);;Argument[0];ReturnValue;taint"
      ]
  }
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

/** Data flow for `System.Net.IPHostEntry`. */
private class SystemNetIPHostEntryClassFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Net;IPHostEntry;false;get_Aliases;();;Argument[Qualifier];ReturnValue;taint",
        "System.Net;IPHostEntry;false;get_HostName;();;Argument[Qualifier];ReturnValue;taint"
      ]
  }
}

/** The `System.Net.Cookie` class. */
class SystemNetCookieClass extends SystemNetClass {
  SystemNetCookieClass() { this.hasName("Cookie") }

  /** Gets the `Value` property. */
  Property getValueProperty() { result = this.getProperty("Value") }
}

/** Data flow for `System.Net.Cookie`. */
private class SystemNetCookieClassFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row = "System.Net;Cookie;false;get_Value;();;Argument[Qualifier];ReturnValue;taint"
  }
}

/** Data flow for `System.Net.HttpListenerPrefixCollection`. */
private class SystemNetHttpListenerPrefixCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Net;HttpListenerPrefixCollection;false;CopyTo;(System.Array,System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
  }
}

/** Data flow for `System.Net.CookieCollection`. */
private class SystemNetCookieCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Net;CookieCollection;false;Add;(System.Net.CookieCollection);;Argument[0];Argument[Qualifier].Element;value"
  }
}

/** Data flow for `System.Net.WebHeaderCollection`. */
private class SystemNetWebHeaderCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Net;WebHeaderCollection;false;Add;(System.String);;Argument[0];Argument[Qualifier].Element;value"
  }
}
