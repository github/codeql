/**
 * Provides a taint-tracking configuration for detecting "Email XSS" vulnerabilities.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.BarrierGuards
import experimental.semmle.python.Concepts
import semmle.python.Concepts
import semmle.python.ApiGraphs

private module EmailXssConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(EmailSender email).getHtmlBody() }

  predicate isBarrier(DataFlow::Node sanitizer) {
    sanitizer = any(HtmlEscaping esc).getOutput()
    or
    sanitizer instanceof ConstCompareBarrier
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallCfgNode htmlContentCall |
      htmlContentCall =
        API::moduleImport("sendgrid")
            .getMember("helpers")
            .getMember("mail")
            .getMember("HtmlContent")
            .getACall() and
      nodeTo = htmlContentCall and
      nodeFrom = htmlContentCall.getArg(0)
    )
  }
}

/** Global taint-tracking for detecting "Email XSS" vulnerabilities. */
module EmailXssFlow = TaintTracking::Global<EmailXssConfig>;
