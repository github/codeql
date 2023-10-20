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
   * A third-party controllable input, considered as a flow source for reflected XSS.
   */
  class UntrustedFlowAsSource extends Source, UntrustedFlowSource { }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink instanceof SharedXss::Sink { }
}
