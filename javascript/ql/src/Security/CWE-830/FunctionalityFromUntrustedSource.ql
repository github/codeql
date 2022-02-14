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
predicate isAllowedHost(string host) { host.toLowerCase().regexpMatch("localhost(:[0-9]+)?/.*") }

bindingset[path]
predicate isUntrustedSourcePath(string path) {
  path.substring(0, 2) = "//"
  or
  exists(string hostPath | hostPath = path.regexpCapture("http://(.*)", 1) |
    not isAllowedHost(hostPath)
  )
}

abstract class IncludesUntrustedContent extends HTML::Element {
  IncludesUntrustedContent() { this = this }

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
    result = "script elements should use an https link and/or use the integrity attribute"
  }
}

/** An iframe element that includes untrusted content. */
class IframeElementWithUntrustedContent extends HTML::IframeElement, IncludesUntrustedContent {
  IframeElementWithUntrustedContent() { isUntrustedSourcePath(this.getSourcePath()) }

  override string getProblem() { result = "iframe elements should use an https link" }
}

from IncludesUntrustedContent s, string problem
where problem = s.getProblem()
select s, "HTML-element imports untrusted content (" + problem + ")"
