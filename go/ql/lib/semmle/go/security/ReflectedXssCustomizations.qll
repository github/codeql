/**
 * Provides classes and predicates used by the Reflected XSS query.
 */

import go
import Xss

/**
 * Provides extension points for customizing the taint-tracking configuration for reasoning about
 * reflected cross-site scripting vulnerabilities.
 */
module ReflectedXss {
  /** A data flow source for reflected XSS vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** A data flow sink for reflected XSS vulnerabilities. */
  abstract class Sink extends DataFlow::Node { }

  /** A sanitizer for reflected XSS vulnerabilities. */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A shared XSS sanitizer as a sanitizer for reflected XSS. */
  private class SharedXssSanitizer extends Sanitizer instanceof SharedXss::Sanitizer { }

  /**
   * A request.Cookie method returns the request cookie, which is not user controlled in reflected XSS context.
   */
  class CookieSanitizer extends Sanitizer {
    CookieSanitizer() {
      exists(Method m, DataFlow::CallNode call | call = m.getACall() |
        m.hasQualifiedName("net/http", "Request", "Cookie") and
        this = call.getResult(0)
      )
    }
  }

  /**
   * DEPRECATED: Use `ActiveThreatModelSource` or `Source` instead.
   */
  deprecated class UntrustedFlowAsSource = ThreatModelFlowAsSource;

  /**
   * A third-party controllable input, considered as a flow source for reflected XSS.
   */
  private class ThreatModelFlowAsSource extends Source instanceof ActiveThreatModelSource { }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink instanceof SharedXss::Sink { }
}
