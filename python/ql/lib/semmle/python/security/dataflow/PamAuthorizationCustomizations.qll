/**
 * Provides default sources, sinks and sanitizers for detecting
 * "PAM Authorization" vulnerabilities.
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "PAM Authorization" vulnerabilities.
 */
module PamAuthorizationCustomizations {
  /**
   * Models a node corresponding to the `pam` library
   */
  API::Node libPam() {
    exists(API::CallNode findLibCall, API::CallNode cdllCall |
      findLibCall =
        API::moduleImport("ctypes").getMember("util").getMember("find_library").getACall() and
      findLibCall.getParameter(0).getAValueReachingSink().asExpr().(StrConst).getText() = "pam" and
      cdllCall = API::moduleImport("ctypes").getMember("CDLL").getACall() and
      cdllCall.getParameter(0).getAValueReachingSink() = findLibCall
    |
      result = cdllCall.getReturn()
    )
  }

  /**
   * A data flow source for "PAM Authorization" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "PAM Authorization" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A vulnerable `pam_authenticate` call considered as a flow sink.
   */
  class VulnPamAuthCall extends API::CallNode, Sink {
    VulnPamAuthCall() {
      exists(DataFlow::Node h |
        this = libPam().getMember("pam_authenticate").getACall() and
        h = this.getArg(0) and
        not exists(API::CallNode acctMgmtCall |
          acctMgmtCall = libPam().getMember("pam_acct_mgmt").getACall() and
          DataFlow::localFlow(h, acctMgmtCall.getArg(0))
        )
      )
    }
  }
}
