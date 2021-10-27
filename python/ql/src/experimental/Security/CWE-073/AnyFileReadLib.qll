import python
import semmle.python.Concepts
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * A taint-tracking configuration for tracking untrusted user input used in file read.
 */
class AnyFileReadFlowConfig extends TaintTracking::Configuration {
  AnyFileReadFlowConfig() { this = "AnyFileReadFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof AnyFileReadSink }

  override predicate isSanitizer(DataFlow::Node node) {
    exists(Compare compare |
      (
        compare.getOp(0) instanceof In or
        compare.getOp(0) instanceof NotIn
      ) and
      compare.getLeft() = node.asExpr()
    )
  }
}

abstract private class FileReadCall extends DataFlow::CallCfgNode { }

private class FlaskSendFileCall extends FileReadCall {
  FlaskSendFileCall() { this = API::moduleImport("flask").getMember("send_file").getACall() }
}

private class OpenReadCall extends FileReadCall {
  OpenReadCall() {
    (
      this = API::builtin("open").getACall() or
      this = API::moduleImport("io").getMember("open").getACall()
    ) and
    this.getArg(1).asExpr().(StrConst).getText().toLowerCase().indexOf("r") > -1
  }
}

/** A data flow sink for any file read vulnerabilities. */
class AnyFileReadSink extends DataFlow::Node {
  AnyFileReadSink() {
    exists(FileReadCall frc, DataFlow::Node pred | frc = pred |
      frc.getArg(0) = this and
      any(ResponseFlowConfig rfc).hasFlow(pred, _)
    )
  }
}

/**
 * A taint-tracking configuration for file content to http response.
 */
private class ResponseFlowConfig extends TaintTracking2::Configuration {
  ResponseFlowConfig() { this = "ResponseFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof FileReadCall }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HTTP::Server::HttpResponse hr).getBody()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::CallCfgNode call |
      call = API::moduleImport("falsk").getMember("make_response").getACall() and
      call.getArg(0) = node1 and
      call = node2
    )
  }
}
