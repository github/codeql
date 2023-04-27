/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext storage of sensitive information, as well as extension
 * points for adding your own.
 */

import javascript
private import semmle.javascript.security.SensitiveActions

module CleartextStorage {
  /**
   * A data flow source for cleartext storage of sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for cleartext storage of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for cleartext storage of sensitive information.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sensitive expression, viewed as a data flow source for cleartext storage
   * of sensitive information.
   */
  class SensitiveExprSource extends Source instanceof SensitiveNode {
    SensitiveExprSource() {
      // storing user names or account names in plaintext isn't usually a problem
      super.getClassification() != SensitiveDataClassification::id()
    }

    override string describe() { result = SensitiveNode.super.describe() }
  }

  /** A call to any function whose name suggests that it encodes or encrypts its arguments. */
  class ProtectSanitizer extends Sanitizer instanceof ProtectCall { }

  /**
   * An expression set as a value on a cookie instance.
   */
  class CookieStorageSink extends Sink {
    CookieStorageSink() {
      exists(Http::CookieDefinition cookieDef |
        this = cookieDef.getValueArgument() or
        this = cookieDef.getHeaderArgument()
      )
    }
  }

  /**
   * An expression set as a value of localStorage or sessionStorage.
   */
  class WebStorageSink extends Sink instanceof WebStorageWrite { }

  /**
   * An expression stored by AngularJS.
   */
  class AngularJSStorageSink extends Sink {
    AngularJSStorageSink() { any(AngularJS::AngularJSCallNode call).storesArgumentGlobally(this) }
  }
}
