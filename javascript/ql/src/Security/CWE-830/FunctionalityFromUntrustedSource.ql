/**
 * @name Inclusion of untrusted functionality by a HTML element.
 * @description Including untrusted functionality by a HTML element
 *              opens up for potential man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.1
 * @precision high
 * @id js/functionality-from-untrusted-source
 * @tags security
 *       external/cwe/cwe-830
 */

import javascript
import semmle.javascript.HTML

bindingset[host]
predicate isLocalhostPrefix(string host) {
  host.toLowerCase()
      .regexpMatch([
          "localhost(:[0-9]+)?/.*", "127.0.0.1(:[0-9]+)?/.*", "::1/.*", "\\[::1\\]:[0-9]+/.*"
        ])
}

/** A path that is vulnerable to a MITM attack. */
bindingset[url]
predicate isUntrustedSourceUrl(string url) {
  url.substring(0, 2) = "//"
  or
  exists(string hostPath | hostPath = url.regexpCapture("http://(.*)", 1) |
    not isLocalhostPrefix(hostPath)
  )
}

/** A path that needs an integrity check — even with https. */
bindingset[url]
predicate isCdnUrlWithCheckingRequired(string url) {
  // Some CDN URLs are required to have an integrity attribute. We only add CDNs to that list
  // that recommend integrity-checking.
  url.regexpMatch([
      "^https?://code\\.jquery\\.com/.*\\.js$", "^https?://cdnjs\\.cloudflare\\.com/.*\\.js$",
      "^https?://cdnjs\\.com/.*\\.js$"
    ])
}

abstract class IncludesUntrustedContent extends HTML::Element {
  /** Gets an explanation why this source is untrusted. */
  abstract string getProblem();
}

/** A script element that refers to untrusted content. */
class ScriptElementWithUntrustedContent extends IncludesUntrustedContent, HTML::ScriptElement {
  ScriptElementWithUntrustedContent() {
    not exists(string digest | not digest = "" | this.getIntegrityDigest() = digest) and
    (
      isUntrustedSourceUrl(this.getSourcePath())
      or
      isCdnUrlWithCheckingRequired(this.getSourcePath())
    )
  }

  override string getProblem() {
    result = "script elements should use an HTTPS url and/or use the integrity attribute"
  }
}

/** An iframe element that includes untrusted content. */
class IframeElementWithUntrustedContent extends HTML::IframeElement, IncludesUntrustedContent {
  IframeElementWithUntrustedContent() { isUntrustedSourceUrl(this.getSourcePath()) }

  override string getProblem() { result = "iframe elements should use an HTTPS url" }
}

from IncludesUntrustedContent s, string problem
where problem = s.getProblem()
select s, "HTML-element uses untrusted content (" + problem + ")"
