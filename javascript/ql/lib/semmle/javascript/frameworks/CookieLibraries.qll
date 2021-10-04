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
     * Holds if the cookie is likely an authentication cookie or otherwise sensitive.
     */
    abstract predicate isSensitive();
  }
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
    result = DataFlow::moduleMember("js-cookie", name).getACall()
  }

  class ReadAccess extends PersistentReadAccess, DataFlow::CallNode {
    ReadAccess() { this = libMemberCall("get") }

    override PersistentWriteAccess getAWrite() {
      getArgument(0).mayHaveStringValue(result.(WriteAccess).getKey())
    }
  }

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode {
    // TODO: CookieWrite
    WriteAccess() { this = libMemberCall("set") }

    string getKey() { getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = getArgument(1) }
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
      getArgument(0).mayHaveStringValue(result.(WriteAccess).getKey())
    }
  }

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode {
    // TODO: CookieWrite
    WriteAccess() { this = libMemberCall("set") }

    string getKey() { getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = getArgument(1) }
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

  class WriteAccess extends PersistentWriteAccess, DataFlow::CallNode {
    // TODO: CookieWrite
    WriteAccess() { this = libMemberCall("serialize") }

    string getKey() { getArgument(0).mayHaveStringValue(result) }

    override DataFlow::Node getValue() { result = getArgument(1) }
  }
}
