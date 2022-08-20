/**
 * @name Inclusion of functionality from an untrusted source
 * @description Including functionality from an untrusted source may allow
 *              an attacker to control the functionality and execute arbitrary code.
 * @kind problem
 * @problem.severity warning
 * @security-severity 6.0
 * @precision high
 * @id js/functionality-from-untrusted-source
 * @tags security
 *       external/cwe/cwe-830
 */

import javascript

/** A location that adds a reference to an untrusted source. */
abstract class AddsUntrustedUrl extends Locatable {
  /** Gets an explanation why this source is untrusted. */
  abstract string getProblem();
}

module StaticCreation {
  /** Holds if `host` is an alias of localhost. */
  bindingset[host]
  predicate isLocalhostPrefix(string host) {
    host.toLowerCase()
        .regexpMatch([
            "(?i)localhost(:[0-9]+)?/.*", "127.0.0.1(:[0-9]+)?/.*", "::1/.*", "\\[::1\\]:[0-9]+/.*"
          ])
  }

  /** Holds if `url` is a url that is vulnerable to a MITM attack. */
  bindingset[url]
  predicate isUntrustedSourceUrl(string url) {
    exists(string hostPath | hostPath = url.regexpCapture("(?i)http://(.*)", 1) |
      not isLocalhostPrefix(hostPath)
    )
  }

  /** Holds if `url` refers to a CDN that needs an integrity check - even with https. */
  bindingset[url]
  predicate isCdnUrlWithCheckingRequired(string url) {
    // Some CDN URLs are required to have an integrity attribute. We only add CDNs to that list
    // that recommend integrity-checking.
    url.regexpMatch("(?i)^https?://" +
        [
          "code\\.jquery\\.com", //
          "cdnjs\\.cloudflare\\.com", //
          "cdnjs\\.com" //
        ] + "/.*\\.js$")
  }

  /** A script element that refers to untrusted content. */
  class ScriptElementWithUntrustedContent extends AddsUntrustedUrl instanceof HTML::ScriptElement {
    ScriptElementWithUntrustedContent() {
      not exists(string digest | not digest = "" | super.getIntegrityDigest() = digest) and
      isUntrustedSourceUrl(super.getSourcePath())
    }

    override string getProblem() { result = "Script loaded using unencrypted connection." }
  }

  /** A script element that refers to untrusted content. */
  class CDNScriptElementWithUntrustedContent extends AddsUntrustedUrl, HTML::ScriptElement {
    CDNScriptElementWithUntrustedContent() {
      not exists(string digest | not digest = "" | this.getIntegrityDigest() = digest) and
      isCdnUrlWithCheckingRequired(this.getSourcePath())
    }

    override string getProblem() {
      result = "Script loaded from content delivery network with no integrity check."
    }
  }

  /** An iframe element that includes untrusted content. */
  class IframeElementWithUntrustedContent extends AddsUntrustedUrl instanceof HTML::IframeElement {
    IframeElementWithUntrustedContent() { isUntrustedSourceUrl(super.getSourcePath()) }

    override string getProblem() { result = "Iframe loaded using unencrypted connection." }
  }
}

module DynamicCreation {
  /** Holds if `call` creates a tag of kind `name`. */
  predicate isCreateElementNode(DataFlow::CallNode call, string name) {
    call = DataFlow::globalVarRef("document").getAMethodCall("createElement") and
    call.getArgument(0).getStringValue().toLowerCase() = name
  }

  DataFlow::Node getAttributeAssignmentRhs(DataFlow::CallNode createCall, string name) {
    result = createCall.getAPropertyWrite(name).getRhs()
    or
    exists(DataFlow::InvokeNode inv | inv = createCall.getAMemberInvocation("setAttribute") |
      inv.getArgument(0).getStringValue() = name and
      result = inv.getArgument(1)
    )
  }

  /**
   * Holds if `createCall` creates a `<script ../>` element which never
   * has its `integrity` attribute set locally.
   */
  predicate isCreateScriptNodeWoIntegrityCheck(DataFlow::CallNode createCall) {
    isCreateElementNode(createCall, "script") and
    not exists(getAttributeAssignmentRhs(createCall, "integrity"))
  }

  DataFlow::Node urlTrackedFromUnsafeSourceLiteral(DataFlow::TypeTracker t) {
    t.start() and result.getStringValue().regexpMatch("(?i)http:.*")
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

  /** Holds if `sink` is assigned to the attribute `name` of any HTML element. */
  predicate isAssignedToSrcAttribute(string name, DataFlow::Node sink) {
    exists(DataFlow::CallNode createElementCall |
      sink = getAttributeAssignmentRhs(createElementCall, "src") and
      (
        name = "script" and
        isCreateScriptNodeWoIntegrityCheck(createElementCall)
        or
        name = "iframe" and
        isCreateElementNode(createElementCall, "iframe")
      )
    )
  }

  class IframeOrScriptSrcAssignment extends AddsUntrustedUrl {
    string name;

    IframeOrScriptSrcAssignment() {
      name = ["script", "iframe"] and
      exists(DataFlow::Node n | n.asExpr() = this |
        isAssignedToSrcAttribute(name, n) and
        n = urlTrackedFromUnsafeSourceLiteral()
      )
    }

    override string getProblem() {
      name = "script" and result = "Script loaded using unencrypted connection."
      or
      name = "iframe" and result = "Iframe loaded using unencrypted connection."
    }
  }
}

from AddsUntrustedUrl s
select s, s.getProblem()
