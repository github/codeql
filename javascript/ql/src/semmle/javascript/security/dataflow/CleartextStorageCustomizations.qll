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
  class SensitiveExprSource extends Source, DataFlow::ValueNode {
    override SensitiveExpr astNode;

    SensitiveExprSource() {
      // storing user names or account names in plaintext isn't usually a problem
      astNode.getClassification() != SensitiveExpr::id()
    }

    override string describe() { result = astNode.describe() }
  }

  /** A call to any function whose name suggests that it encodes or encrypts its arguments. */
  class ProtectSanitizer extends Sanitizer {
    ProtectSanitizer() { this instanceof ProtectCall }
  }

  /**
   * An expression set as a value on a cookie instance.
   */
  class CookieStorageSink extends Sink {
    CookieStorageSink() {
      exists(HTTP::CookieDefinition cookieDef |
        this.asExpr() = cookieDef.getValueArgument() or
        this.asExpr() = cookieDef.getHeaderArgument()
      )
    }
  }

  /**
   * An expression set as a value of localStorage or sessionStorage.
   */
  class WebStorageSink extends Sink {
    WebStorageSink() { this.asExpr() instanceof WebStorageWrite }
  }

  /**
   * An expression stored by AngularJS.
   */
  class AngularJSStorageSink extends Sink {
    AngularJSStorageSink() {
      any(AngularJS::AngularJSCall call).storesArgumentGlobally(this.asExpr())
    }
  }
}
