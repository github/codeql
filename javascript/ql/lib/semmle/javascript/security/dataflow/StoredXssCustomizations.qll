/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * stored cross-site scripting vulnerabilities.
 */

import javascript

module StoredXss {
  private import Xss::Shared as Shared

  /** A data flow source for stored XSS vulnerabilities. */
  abstract class Source extends Shared::Source { }

  /** A data flow sink for stored XSS vulnerabilities. */
  abstract class Sink extends Shared::Sink { }

  /** A sanitizer for stored XSS vulnerabilities. */
  abstract class Sanitizer extends Shared::Sanitizer { }

  /** A sanitizer guard for stored XSS vulnerabilities. */
  abstract class SanitizerGuard extends Shared::SanitizerGuard { }

  /** An arbitrary XSS sink, considered as a flow sink for stored XSS. */
  private class AnySink extends Sink {
    AnySink() { this instanceof Shared::Sink }
  }

  /**
   * A regexp replacement involving an HTML meta-character, viewed as a sanitizer for
   * XSS vulnerabilities.
   *
   * The XSS queries do not attempt to reason about correctness or completeness of sanitizers,
   * so any such replacement stops taint propagation.
   */
  private class MetacharEscapeSanitizer extends Sanitizer, Shared::MetacharEscapeSanitizer { }

  private class UriEncodingSanitizer extends Sanitizer, Shared::UriEncodingSanitizer { }

  private class SerializeJavascriptSanitizer extends Sanitizer, Shared::SerializeJavascriptSanitizer {
  }

  private class IsEscapedInSwitchSanitizer extends Sanitizer, Shared::IsEscapedInSwitchSanitizer { }

  private class QuoteGuard extends SanitizerGuard, Shared::QuoteGuard { }

  private class ContainsHtmlGuard extends SanitizerGuard, Shared::ContainsHtmlGuard { }
}
