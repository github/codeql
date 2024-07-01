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

    API::Node sessionObject() { result = requests().getMember("Session") }

    module RequestObject { 
      class RequestObject extends DataFlow::CallCfgNode {
        RequestObject() {
          this = requestObject().getACall()
        }

        DataFlow::Node getAUrlPart() {
          result = this.getArg(1)
        }
      }

      DataFlow::TypeTrackingNode instance(TypeTracker tt) {
        tt.start() and 
        result instanceof RequestObject
        or
        exists(TypeTracker tt2 |
          tt = tt2.step(instance(tt2), result)
        )
      }

      DataFlow::Node instance() { instance(TypeTracker::end()).flowsTo(result) }    
    }

    class PrepareCall extends DataFlow::MethodCallNode {
      PrepareCall() {
          this.calls(RequestObject::instance(), "prepare")
      }

      DataFlow::TypeTrackingNode getARequestObject(TypeBackTracker tt) {
        tt.start() and 
        result = this.getObject().getALocalSource()
        or
        exists(TypeBackTracker tt2 |
          tt = tt2.step(result, this.getARequestObject(tt2))
        )
      }
    
      RequestObject::RequestObject getARequestObject() { result = this.getARequestObject(TypeBackTracker::end())}
    }

    class OutgoingSessionObjectSendCall extends Http::Client::Request::Range, API::CallNode {
      OutgoingSessionObjectSendCall() {
        this = sessionObject().getACall().getAMethodCall("send")
      }

      override DataFlow::Node getAUrlPart() {
        result = this.getAPrepareCall().getARequestObject().getAUrlPart()
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
          tt = tt2.step(result, this.getAPrepareCall(tt2))
        )
      }
    
      PrepareCall getAPrepareCall() { result = this.getAPrepareCall(TypeBackTracker::end())}
    }
  }
}
