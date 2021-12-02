import python
import DataFlow
import semmle.python.Concepts
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2
import semmle.python.dataflow.new.RemoteFlowSources
import experimental.semmle.python.Concepts

/**
 * A call to the `werkzeug.utils.secure_filename` function.
 *
 * See https://werkzeug.palletsprojects.com/en/2.0.x/utils/#werkzeug.utils.secure_filename
 */
private class WerkzeugUtilsSecureFilenameCall extends DataFlow::CallCfgNode {
  WerkzeugUtilsSecureFilenameCall() {
    this = API::moduleImport("werkzeug").getMember("utils").getMember("secure_filename").getACall()
  }

  DataFlow::Node getArgument() { result in [this.getArg(0), this.getArgByName("filename")] }
}

/**
 * A taint-tracking configuration for tracking untrusted user input used in file reading and deletion.
 */
class ArbitraryFileReadAndDeleteFlowConfig extends TaintTracking::Configuration {
  ArbitraryFileReadAndDeleteFlowConfig() { this = "ArbitraryFileReadAndDeleteFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof ArbitraryFileReadSink or
    sink instanceof ArbitraryFileOrDirRemoveSink
  }

  override predicate isSanitizer(DataFlow::Node node) {
    node = any(WerkzeugUtilsSecureFilenameCall wusf).getArgument()
  }
}

/** A data flow sink for arbitrary file remove vulnerabilities. */
private class ArbitraryFileOrDirRemoveSink extends DataFlow::Node {
  ArbitraryFileOrDirRemoveSink() { this = any(FileRemove fr).getAPathArgument() }
}

/** A data flow sink for arbitrary file read vulnerabilities. */
private class ArbitraryFileReadSink extends DataFlow::Node {
  ArbitraryFileReadSink() {
    exists(FileOpen fo |
      fo.getAPathArgument() = this and
      any(FileContentResponseFlowConfig rfc).hasFlow(fo.getCall(), _)
    )
  }
}

/**
 * A taint-tracking configuration for file content to http response.
 */
class FileContentResponseFlowConfig extends TaintTracking2::Configuration {
  FileContentResponseFlowConfig() { this = "FileContentResponseFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source = any(FileOpen fo).getCall() }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(HTTP::Server::HttpResponse hr).getBody()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::CallCfgNode call |
      call = API::moduleImport("os").getMember("fdopen").getACall() and
      call.getArg(0) = node1 and
      call = node2
    )
    or
    exists(DataFlow::CallCfgNode ccn |
      ccn.getFunction().(AttrRead).getAttributeName() in ["read_text", "read_bytes"] and
      ccn.getFunction().(AttrRead).getObject() = node1 and
      ccn = node2
    )
  }
}
