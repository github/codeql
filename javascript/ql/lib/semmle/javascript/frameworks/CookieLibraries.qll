/**
 * Provides classes for reasoning about cookies.
 */

import javascript

/**
 * Classes and predicates for reasoning about writes to cookies.
 */
module CookieWrites {
  /**
   * A write to a cookie.
   */
  abstract class CookieWrite extends DataFlow::Node {
    /**
     * Holds if this cookie is secure, i.e. only transmitted over SSL.
     */
    abstract predicate isSecure();

    /**
     * Holds if this cookie is HttpOnly, i.e. not accessible by JavaScript.
     */
    abstract predicate isHttpOnly();

    /**
     * Holds if the cookie likely is an authentication cookie or otherwise sensitive.
     */
    abstract predicate isSensitive();

    /**
     * Gets the SameSite attribute of the cookie if present.
     * Either "Strict", "Lax" or "None".
     */
    abstract string getSameSite();

    /**
     * Holds if the cookie write happens on a server, i.e. the `httpOnly` flag is relevant.
     */
    predicate isServerSide() {
      any() // holds by default. Client-side cookie writes should extend ClientSideCookieWrite.
    }
  }

  /**
   * A client-side write to a cookie.
   */
  abstract class ClientSideCookieWrite extends CookieWrite {
    final override predicate isHttpOnly() { none() }

    final override predicate isServerSide() { none() }
  }

  /**
   * Gets the flag that indicates that a cookie is secure.
   */
  string secure() { result = "secure" }

  /**
   * Gets the flag that indicates that a cookie is HttpOnly.
   */
  string httpOnly() { result = "httpOnly" }
}

/**
 * Holds if `node` looks like it can contain a sensitive cookie.
 *
 * Heuristics:
 * - `node` contains a string value that looks like a sensitive cookie name
 * - `node` is a sensitive expression
 */
private predicate canHaveSensitiveCookie(DataFlow::Node node) {
  exists(string s |
    node.mayHaveStringValue(s) or
    s = node.(StringOps::ConcatenationRoot).getConstantStringParts()
  |
    HeuristicNames::nameIndicatesSensitiveData([s, getCookieName(s)], _)
  )
  or
  node.asExpr() instanceof SensitiveExpr
}

/**
 * Gets the cookie name of a `Set-Cookie` header value.
 * The header value always starts with `<cookie-name>=<cookie-value>` optionally followed by attributes:
 * `<cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly`
 */
bindingset[s]
private string getCookieName(string s) { result = s.regexpCapture("([^=]*)=.*", 1).trim() }

/**
 * Holds if the `Set-Cookie` header value contains the specified attribute
 * 1. The attribute is case insensitive
 * 2. It always starts with a pair `<cookie-name>=<cookie-value>`.
 *    If the attribute is present there must be `;` after the pair.
 *    Other attributes like `Domain=`, `Path=`, etc. may come after the pair:
 *    `<cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly`
 * See `https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie`
 */
bindingset[s, attribute]
private predicate hasCookieAttribute(string s, string attribute) {
  s.regexpMatch("(?i).*;\\s*" + attribute + "\\b\\s*;?.*$")
}

/**
 * Gets the value for a `Set-Cookie` header attribute.
 */
bindingset[s, attribute]
private string getCookieValue(string s, string attribute) {
  result = s.regexpCapture("(?i).*;\\s*" + attribute + "=(\\w+)\\b\\s*;?.*$", 1)
}

/**
 * Gets the "SameSite" value for a given `node`.
 * Converts boolean values to the corresponding string value.
 *
 * Not all libraries support boolean values for the `SameSite` attribute,
 * but here we assume that they do.
 */
private string getSameSiteValue(DataFlow::Node node) {
  node.mayHaveStringValue(result)
  or
  node.mayHaveBooleanValue(true) and
  result = "Strict"
  or
  node.mayHaveBooleanValue(false) and
  result = "Lax"
}

/**
 * A model of the `js-cookie` library (https://github.com/js-cookie/js-cookie).
 */
private module JsCookie {
  /**
   * Gets a function call that invokes method `name` of the `js-cookie` library.
   */
  DataFlow::CallNode libMemberCall(string name) {
    result = DataFlow::globalVarRef("Cookie").getAMemberCall(name) or
    result = DataFlow::globalVarRef("Cookie").getAMemberCall("noConflict").getAMemberCall(name) or
    result = DataFlow::moduleMember("js-cookie", name).getACall() or
    // es-cookie behaves basically the same as js-cookie
    result = DataFlow::moduleMember("es-cookie", name).getACall()
  }

  class ReadAccess extends PersistentReadAccess, DataFlow::CallNode {
    ReadAccess() { this = libMemberCall("get") }

    override PersistentWriteAccess getAWrite() {
      this.getArgument(0).mayHaveStringValue(result.(WriteAccess).getKey())
    }
  }

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode,
    CookieWrites::ClientSideCookieWrite {
    WriteAccess() { this = libMemberCall("set") }

    string getKey() { this.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      exists(DataFlow::Node value | value = this.getOptionArgument(2, CookieWrites::secure()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
    }

    override predicate isSensitive() { canHaveSensitiveCookie(this.getArgument(0)) }

    override string getSameSite() {
      result = getSameSiteValue(this.getOptionArgument(2, "sameSite"))
    }
  }
}

/**
 * A model of the `browser-cookies` library (https://github.com/voltace/browser-cookies).
 */
private module BrowserCookies {
  /**
   * Gets a function call that invokes method `name` of the `browser-cookies` library.
   */
  DataFlow::CallNode libMemberCall(string name) {
    result = DataFlow::moduleMember("browser-cookies", name).getACall()
  }

  class ReadAccess extends PersistentReadAccess, DataFlow::CallNode {
    ReadAccess() { this = libMemberCall("get") }

    override PersistentWriteAccess getAWrite() {
      this.getArgument(0).mayHaveStringValue(result.(WriteAccess).getKey())
    }
  }

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode,
    CookieWrites::ClientSideCookieWrite {
    WriteAccess() { this = libMemberCall("set") }

    string getKey() { this.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      exists(DataFlow::Node value | value = this.getOptionArgument(2, CookieWrites::secure()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
      or
      // or, an explicit default has been set
      exists(DataFlow::moduleMember("browser-cookies", "defaults").getAPropertyWrite("secure"))
    }

    override predicate isSensitive() { canHaveSensitiveCookie(this.getArgument(0)) }

    override string getSameSite() {
      result = getSameSiteValue(this.getOptionArgument(2, "samesite"))
      or
      // or, an explicit default has been set
      DataFlow::moduleMember("browser-cookies", "defaults")
          .getAPropertyWrite("samesite")
          .mayHaveStringValue(result)
    }
  }
}

/**
 * A model of the `cookie` library (https://github.com/jshttp/cookie).
 */
private module LibCookie {
  /**
   * Gets a function call that invokes method `name` of the `cookie` library.
   */
  DataFlow::CallNode libMemberCall(string name) {
    result = DataFlow::moduleMember("cookie", name).getACall()
  }

  class ReadAccess extends PersistentReadAccess {
    string key;

    ReadAccess() { this = libMemberCall("parse").getAPropertyRead(key) }

    override PersistentWriteAccess getAWrite() { key = result.(WriteAccess).getKey() }
  }

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode,
    CookieWrites::ClientSideCookieWrite {
    WriteAccess() { this = libMemberCall("serialize") }

    string getKey() { this.getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = this.getArgument(1) }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      exists(DataFlow::Node value | value = this.getOptionArgument(2, CookieWrites::secure()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
    }

    override predicate isSensitive() { canHaveSensitiveCookie(this.getArgument(0)) }

    override string getSameSite() {
      result = getSameSiteValue(this.getOptionArgument(2, "sameSite"))
    }
  }
}

/**
 * A model of cookies in an express application.
 */
private module ExpressCookies {
  /**
   * A cookie set using `response.cookie` from `express` module (https://expressjs.com/en/api.html#res.cookie).
   */
  private class InsecureExpressCookieResponse extends CookieWrites::CookieWrite,
    DataFlow::MethodCallNode {
    InsecureExpressCookieResponse() { this.asExpr() instanceof Express::SetCookie }

    override predicate isSecure() {
      // A cookie is secure if there are cookie options with the `secure` flag set to `true`.
      // The default is `false`.
      exists(DataFlow::Node value | value = this.getOptionArgument(2, CookieWrites::secure()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
    }

    override predicate isSensitive() { canHaveSensitiveCookie(this.getArgument(0)) }

    override predicate isHttpOnly() {
      // A cookie is httpOnly if there are cookie options with the `httpOnly` flag set to `true`.
      // The default is `false`.
      exists(DataFlow::Node value | value = this.getOptionArgument(2, CookieWrites::httpOnly()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
    }

    override string getSameSite() {
      result = getSameSiteValue(this.getOptionArgument(2, "sameSite"))
    }
  }

  /**
   * A cookie set using the `express` module `cookie-session` (https://github.com/expressjs/cookie-session).
   */
  class InsecureCookieSession extends ExpressLibraries::CookieSession::MiddlewareInstance,
    CookieWrites::CookieWrite {
    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getOptionArgument(0, flag)
    }

    override predicate isSecure() {
      // The flag `secure` is set to `false` by default for HTTP, `true` by default for HTTPS (https://github.com/expressjs/cookie-session#cookie-options).
      // A cookie is secure if the `secure` flag is not explicitly set to `false`.
      not this.getCookieFlagValue(CookieWrites::secure()).mayHaveBooleanValue(false)
    }

    override predicate isSensitive() {
      any() // It is a session cookie, likely auth sensitive
    }

    override predicate isHttpOnly() {
      // The flag `httpOnly` is set to `true` by default (https://github.com/expressjs/cookie-session#cookie-options).
      // A cookie is httpOnly if the `httpOnly` flag is not explicitly set to `false`.
      not this.getCookieFlagValue(CookieWrites::httpOnly()).mayHaveBooleanValue(false)
    }

    override string getSameSite() { result = getSameSiteValue(this.getCookieFlagValue("sameSite")) }
  }

  /**
   * A cookie set using the `express` module `express-session` (https://github.com/expressjs/session).
   */
  class InsecureExpressSessionCookie extends ExpressLibraries::ExpressSession::MiddlewareInstance,
    CookieWrites::CookieWrite {
    private DataFlow::Node getCookieFlagValue(string flag) {
      result = this.getOption("cookie").getALocalSource().getAPropertyWrite(flag).getRhs()
    }

    override predicate isSecure() {
      // The flag `secure` is not set by default (https://github.com/expressjs/session#Cookiesecure).
      // The default value for cookie options is { path: '/', httpOnly: true, secure: false, maxAge: null }.
      exists(DataFlow::Node value | value = this.getCookieFlagValue(CookieWrites::secure()) |
        not value.mayHaveBooleanValue(false) // anything but `false` is accepted as being maybe true
      )
    }

    override predicate isSensitive() {
      any() // It is a session cookie, likely auth sensitive
    }

    override predicate isHttpOnly() {
      // The flag `httpOnly` is set by default (https://github.com/expressjs/session#Cookiesecure).
      // The default value for cookie options is { path: '/', httpOnly: true, secure: false, maxAge: null }.
      // A cookie is httpOnly if the `httpOnly` flag is not explicitly set to `false`.
      not this.getCookieFlagValue(CookieWrites::httpOnly()).mayHaveBooleanValue(false)
    }

    override string getSameSite() { result = getSameSiteValue(this.getCookieFlagValue("sameSite")) }
  }
}

/**
 * A cookie set using `Set-Cookie` header of an `HTTP` response, where a raw header is used.
 * (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie).
 * This class does not model the Express implementation of `HTTP::CookieDefintion`
 * as the express implementation does not use raw headers.
 *
 * In case an array is passed `setHeader("Set-Cookie", [...]` it sets multiple cookies.
 * We model a `CookieWrite` for each array element.
 */
private class HttpCookieWrite extends CookieWrites::CookieWrite {
  string header;

  HttpCookieWrite() {
    exists(HTTP::CookieDefinition setCookie |
      this.asExpr() = setCookie.getHeaderArgument() and
      not this instanceof DataFlow::ArrayCreationNode
      or
      this = setCookie.getHeaderArgument().flow().(DataFlow::ArrayCreationNode).getAnElement()
    ) and
    header =
      [
        any(string s | this.mayHaveStringValue(s)),
        this.(StringOps::ConcatenationRoot).getConstantStringParts()
      ]
  }

  override predicate isSecure() {
    // A cookie is secure if the `secure` flag is specified in the cookie definition.
    //  The default is `false`.
    hasCookieAttribute(header, CookieWrites::secure())
  }

  override predicate isHttpOnly() {
    // A cookie is httpOnly if the `httpOnly` flag is specified in the cookie definition.
    // The default is `false`.
    hasCookieAttribute(header, CookieWrites::httpOnly())
  }

  override predicate isSensitive() { canHaveSensitiveCookie(this) }

  override string getSameSite() { result = getCookieValue(header, "SameSite") }
}

/**
 * A write to `document.cookie`.
 */
private class DocumentCookieWrite extends CookieWrites::ClientSideCookieWrite {
  string cookie;
  DataFlow::PropWrite write;

  DocumentCookieWrite() {
    this = write and
    write = DOM::documentRef().getAPropertyWrite("cookie") and
    cookie =
      [
        any(string s | write.getRhs().mayHaveStringValue(s)),
        write.getRhs().(StringOps::ConcatenationRoot).getConstantStringParts()
      ]
  }

  override predicate isSecure() {
    // A cookie is secure if the `secure` flag is specified in the cookie definition.
    // The default is `false`.
    hasCookieAttribute(cookie, CookieWrites::secure())
  }

  override predicate isSensitive() { canHaveSensitiveCookie(write.getRhs()) }

  override string getSameSite() { result = getCookieValue(cookie, "SameSite") }
}
