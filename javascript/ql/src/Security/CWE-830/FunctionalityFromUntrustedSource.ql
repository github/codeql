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
import semmle.javascript.dataflow.TaintTracking

module Generic {
  /** A `CallNode` that creates an element of kind `name`. */
  predicate isCreateElementNode(DataFlow::CallNode call, string name) {
    call = DataFlow::globalVarRef("document").getAMethodCall("createElement") and
    call.getArgument(0).getStringValue().toLowerCase() = name
  }

  /**
   * A `createElement` call that creates a `<script ../>` element which never
   * has its `integrity` attribute set locally.
   */
  predicate isCreateScriptNodeWoIntegrityCheck(DataFlow::CallNode createCall) {
    isCreateElementNode(createCall, "script") and
    not exists(createCall.getAPropertyWrite("integrity"))
  }

  /** A location that adds a reference to an untrusted source. */
  abstract class AddsUntrustedUrl extends Locatable {
    /** Gets an explanation why this source is untrusted. */
    abstract string getProblem();
  }
}

module StaticCreation {
  bindingset[host]
  predicate isLocalhostPrefix(string host) {
    host.toLowerCase()
        .regexpMatch([
            "(?i)localhost(:[0-9]+)?/.*", "127.0.0.1(:[0-9]+)?/.*", "::1/.*", "\\[::1\\]:[0-9]+/.*"
          ])
  }

  /** A path that is vulnerable to a MITM attack. */
  bindingset[url]
  predicate isUntrustedSourceUrl(string url) {
    exists(string hostPath | hostPath = url.regexpCapture("(?i)http://(.*)", 1) |
      not isLocalhostPrefix(hostPath)
    )
  }

  /** A path that needs an integrity check - even with https. */
  bindingset[url]
  predicate isCdnUrlWithCheckingRequired(string url) {
    // Some CDN URLs are required to have an integrity attribute. We only add CDNs to that list
    // that recommend integrity-checking.
    url.regexpMatch("(?i)" +
        [
          "^https?://code\\.jquery\\.com/.*\\.js$", "^https?://cdnjs\\.cloudflare\\.com/.*\\.js$",
          "^https?://cdnjs\\.com/.*\\.js$"
        ])
  }

  /** A script element that refers to untrusted content. */
  class ScriptElementWithUntrustedContent extends Generic::AddsUntrustedUrl, HTML::ScriptElement {
    ScriptElementWithUntrustedContent() {
      not exists(string digest | not digest = "" | this.getIntegrityDigest() = digest) and
      isUntrustedSourceUrl(this.getSourcePath())
    }

    override string getProblem() {
      result = "script elements should use an 'https:' URL and/or use the integrity attribute"
    }
  }

  /** A script element that refers to untrusted content. */
  class CDNScriptElementWithUntrustedContent extends Generic::AddsUntrustedUrl, HTML::ScriptElement {
    CDNScriptElementWithUntrustedContent() {
      not exists(string digest | not digest = "" | this.getIntegrityDigest() = digest) and
      isCdnUrlWithCheckingRequired(this.getSourcePath())
    }

    override string getProblem() {
      result =
        "script elements that depend on this CDN should use an 'https:' URL and use the integrity attribute"
    }
  }

  /** An iframe element that includes untrusted content. */
  class IframeElementWithUntrustedContent extends HTML::IframeElement, Generic::AddsUntrustedUrl {
    IframeElementWithUntrustedContent() { isUntrustedSourceUrl(this.getSourcePath()) }

    override string getProblem() { result = "iframe elements should use an 'https:' URL" }
  }
}

module DynamicCreation {
  import DataFlow::TypeTracker

  predicate isUnsafeSourceLiteral(DataFlow::Node source) {
    exists(StringLiteral s | source = s.flow() | s.getValue().regexpMatch("(?i)http:.*"))
  }

  DataFlow::Node urlTrackedFromUnsafeSourceLiteral(DataFlow::TypeTracker t) {
    t.start() and isUnsafeSourceLiteral(result)
    or
    exists(DataFlow::TypeTracker t2, DataFlow::Node prev |
      prev = urlTrackedFromUnsafeSourceLiteral(t2)
    |
      not exists(string httpsUrl | httpsUrl.toLowerCase() = "https:" + any(string rest) |
        // when the result may have a string value starting with https,
        // we're most likely with an assignment like:
        // e.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js'
        // these assignments, we don't want to fix - once the browser is using http,
        // MITM attacks are possible anyway.
        result.mayHaveStringValue(httpsUrl)
      ) and
      (
        t2 = t.smallstep(prev, result)
        or
        TaintTracking::sharedTaintStep(prev, result) and
        t = t2
      )
    )
  }

  DataFlow::Node urlTrackedFromUnsafeSourceLiteral() {
    result = urlTrackedFromUnsafeSourceLiteral(DataFlow::TypeTracker::end())
  }

  predicate isAssignedToSrcAttribute(string name, DataFlow::Node sink) {
    exists(DataFlow::CallNode createElementCall |
      name = "script" and
      Generic::isCreateScriptNodeWoIntegrityCheck(createElementCall) and
      sink = createElementCall.getAPropertyWrite("src").getRhs()
      or
      name = "iframe" and
      Generic::isCreateElementNode(createElementCall, "iframe") and
      sink = createElementCall.getAPropertyWrite("src").getRhs()
    )
  }

  class IframeOrScriptSrcAssignment extends Expr, Generic::AddsUntrustedUrl {
    string name;

    IframeOrScriptSrcAssignment() {
      exists(DataFlow::Node n | n.asExpr() = this |
        DynamicCreation::isAssignedToSrcAttribute(name, n) and
        n = DynamicCreation::urlTrackedFromUnsafeSourceLiteral()
      )
    }

    override string getProblem() {
      name = "script" and
      result = "script elements should use an 'https:' URL and/or use the integrity attribute"
      or
      name = "iframe" and result = "iframe elements should use an 'https:' URL"
    }
  }
}

from Generic::AddsUntrustedUrl s
select s, "HTML-element uses untrusted content (" + s.getProblem() + ")"
