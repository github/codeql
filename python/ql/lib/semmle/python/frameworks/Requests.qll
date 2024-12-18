/**
 * Provides classes modeling security-relevant aspects of the `requests` PyPI package.
 *
 * See
 * - https://pypi.org/project/requests/
 * - https://docs.python-requests.org/en/latest/
 */

private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.Stdlib
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `requests` PyPI package.
 *
 * See
 * - https://pypi.org/project/requests/
 * - https://requests.readthedocs.io/en/latest/
 */
module Requests {
  /**
   * An outgoing HTTP request, from the `requests` library.
   *
   * See https://requests.readthedocs.io/en/latest/api/#requests.request
   */
  private class OutgoingRequestCall extends Http::Client::Request::Range, API::CallNode {
    string methodName;

    OutgoingRequestCall() {
      methodName in [Http::httpVerbLower(), "request"] and
      (
        this = API::moduleImport("requests").getMember(methodName).getACall()
        or
        exists(API::Node moduleExporting, API::Node sessionInstance |
          moduleExporting in [
              API::moduleImport("requests"), //
              API::moduleImport("requests").getMember("sessions")
            ] and
          sessionInstance = moduleExporting.getMember(["Session", "session"]).getReturn()
        |
          this = sessionInstance.getMember(methodName).getACall()
        )
      )
    }

    override DataFlow::Node getAUrlPart() {
      result = this.getArgByName("url")
      or
      not methodName = "request" and
      result = this.getArg(0)
      or
      methodName = "request" and
      result = this.getArg(1)
    }

    override predicate disablesCertificateValidation(
      DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
    ) {
      disablingNode = this.getKeywordParameter("verify").asSink() and
      argumentOrigin = this.getKeywordParameter("verify").getAValueReachingSink() and
      // requests treats `None` as the default and all other "falsey" values as `False`.
      argumentOrigin.asExpr().(ImmutableLiteral).booleanValue() = false and
      not argumentOrigin.asExpr() instanceof None
    }

    override string getFramework() { result = "requests" }
  }

  /**
   * Extra taint propagation for outgoing requests calls,
   * to ensure that responses to user-controlled URL are tainted.
   */
  private class OutgoingRequestCallTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      nodeFrom = nodeTo.(OutgoingRequestCall).getAUrlPart()
    }
  }

  // ---------------------------------------------------------------------------
  // Response
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `requests.models.Response` class
   *
   * See https://requests.readthedocs.io/en/latest/api/#requests.Response.
   */
  module Response {
    /** Gets a reference to the `requests.models.Response` class. */
    API::Node classRef() {
      result = API::moduleImport("requests").getMember("models").getMember("Response")
      or
      result = API::moduleImport("requests").getMember("Response")
      or
      result = ModelOutput::getATypeNode("requests.models.Response~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `requests.models.Response`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Response::instance()` to get references to instances of `requests.models.Response`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `requests.models.Response`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Return value from making a request. */
    private class RequestReturnValue extends InstanceSource, DataFlow::Node {
      RequestReturnValue() { this = any(OutgoingRequestCall c) }
    }

    /** Gets a reference to an instance of `requests.models.Response`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `requests.models.Response`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `requests.models.Response`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "requests.models.Response" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in ["text", "content", "raw", "links", "cookies", "headers"]
      }

      override string getMethodName() { result in ["json", "iter_content", "iter_lines"] }

      override string getAsyncMethodName() { none() }
    }

    /** An attribute read that is a file-like instance. */
    private class FileLikeInstances extends Stdlib::FileLikeObject::InstanceSource {
      FileLikeInstances() {
        this.(DataFlow::AttrRead).getObject() = instance() and
        this.(DataFlow::AttrRead).getAttributeName() = "raw"
      }
    }
  }
}
