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

bindingset[path]
predicate isUntrustedSourcePath(string path) {
  path.substring(0, 2) = "//"
  or
  exists(string hostPath | hostPath = path.regexpCapture("http://(.*)", 1) |
    not isLocalhostPrefix(hostPath)
  )
}

abstract class IncludesUntrustedContent extends HTML::Element {
  /** Gets an explanation why this source is untrusted. */
  abstract string getProblem();
}

/** A script element that refers to untrusted content. */
class ScriptElementWithUntrustedContent extends IncludesUntrustedContent, HTML::ScriptElement {
  ScriptElementWithUntrustedContent() {
    isUntrustedSourcePath(this.getSourcePath()) and
    not exists(string digest | not digest = "" | this.getIntegrityDigest() = digest)
  }

  override string getProblem() {
    result = "script elements should use an HTTPS url and/or use the integrity attribute"
  }
}

/** An iframe element that includes untrusted content. */
class IframeElementWithUntrustedContent extends HTML::IframeElement, IncludesUntrustedContent {
  IframeElementWithUntrustedContent() { isUntrustedSourcePath(this.getSourcePath()) }

  override string getProblem() { result = "iframe elements should use an HTTPS url" }
}

from IncludesUntrustedContent s, string problem
where problem = s.getProblem()
select s, "HTML-element uses untrusted content (" + problem + ")"
