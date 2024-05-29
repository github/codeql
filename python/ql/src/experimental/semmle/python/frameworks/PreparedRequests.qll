private import python
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.TypeTracking
  
module ExperimentalRequests {

  API::Node requests() { result = API::moduleImport("requests") }

  /**
   * An outgoing Http Requests using Prepared Request, from the `requests` library 
   * 
   * See https://requests.readthedocs.io/en/latest/user/advanced/#prepared-requests
   */
  module ExperimentalPreparedRequests { 
    API::Node requestObject() { result = requests().getMember("Request") }

    API::Node sessionObject() { result = API::moduleImport("requests").getMember("Session") }

    class RequestObject extends DataFlow::CallCfgNode {
      RequestObject() {
        this = requestObject().getACall()
      }

      DataFlow::Node getAUrlPart() {
        result = this.getArg(1)
      }

      DataFlow::Node getPrepareCall() {
        result = this.getAMethodCall("prepare")
      }
    }

    class OutgoingSessionObjectSendCall extends Http::Client::Request::Range, API::CallNode {
      OutgoingSessionObjectSendCall() {
        this = sessionObject().getACall().getAMethodCall("send")
      }

      override DataFlow::Node getAUrlPart() {
        result = this.getARequestObject().getAUrlPart()
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

      DataFlow::TypeTrackingNode getAPrepareCall(TypeBackTracker tt) {
        tt.start() and 
        result = this.getArg(0).getALocalSource()
        or
        exists(TypeBackTracker tt2 |
          tt = tt2.step(result, this.getAPrepareCall( tt2))
        )
      }
    
      DataFlow::Node getAPrepareCall() { result = this.getAPrepareCall(TypeBackTracker::end())}
    
      DataFlow::TypeTrackingNode getARequestObject(TypeBackTracker tt) {
        tt.start() and 
        (
          exists(RequestObject ro | 
            ro.getPrepareCall() = this.getAPrepareCall().getALocalSource() and 
            result = ro.getALocalSource())
        )
        or
        exists(TypeBackTracker tt2 |
          tt = tt2.step(result, this.getARequestObject(tt2))
        )
      }
    
      RequestObject getARequestObject() { result = this.getARequestObject(TypeBackTracker::end())}

    }
  }
}
