/**
 * Module for working with uses of the [Trusted Types API](https://developer.mozilla.org/en-US/docs/Web/API/Trusted_Types_API)
 */

private import javascript
private import semmle.javascript.security.dataflow.Xss
private import semmle.javascript.security.dataflow.ClientSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations

/**
 * Module for working with uses of the [Trusted Types API](https://developer.mozilla.org/en-US/docs/Web/API/Trusted_Types_API).
 */
module TrustedTypes {
  private class TrustedTypesEntry extends API::EntryPoint {
    TrustedTypesEntry() { this = "TrustedTypesEntry" }

    override DataFlow::SourceNode getAUse() { result = DataFlow::globalVarRef("trustedTypes") }

    override DataFlow::Node getARhs() { none() }
  }

  private API::Node trustedTypesObj() { result = any(TrustedTypesEntry entry).getANode() }

  /** A call to `trustedTypes.createPolicy`. */
  class PolicyCreation extends API::CallNode {
    PolicyCreation() { this = trustedTypesObj().getMember("createPolicy").getACall() }

    /** Gets the function passed as the given option. */
    DataFlow::FunctionNode getPolicyCallback(string method) {
      // Require local callback to avoid potential call/return mismatch in the uses below
      result = getOptionArgument(1, method).getALocalSource()
    }
  }

  /**
   * A data-flow step from the use of a policy to its callback.
   */
  private class PolicyInputStep extends DataFlow::SharedFlowStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(PolicyCreation policy, string method |
        pred = policy.getReturn().getMember(method).getParameter(0).getARhs() and
        succ = policy.getPolicyCallback(method).getParameter(0)
      )
    }
  }

  /**
   * The creation of a trusted HTML object, as an XSS sink.
   */
  private class XssSink extends DomBasedXss::Sink {
    XssSink() { this = any(PolicyCreation creation).getPolicyCallback("createHTML").getAReturn() }
  }

  /**
   * The creation of a trusted script, as a code-injection sink.
   */
  private class CodeInjectionSink extends CodeInjection::Sink {
    CodeInjectionSink() {
      this = any(PolicyCreation creation).getPolicyCallback("createScript").getAReturn()
    }
  }

  /**
   * The creation of a trusted script URL, as a URL redirection sink.
   *
   * This is currently handled by the client-side URL redirection query, as this checks for untrusted hostname in the URL.
   */
  private class UrlSink extends ClientSideUrlRedirect::Sink {
    UrlSink() {
      this = any(PolicyCreation creation).getPolicyCallback("createScriptURL").getAReturn()
    }
  }
}
