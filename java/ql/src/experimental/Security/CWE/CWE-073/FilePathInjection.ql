/**
 * @name File Path Injection
 * @description Loading files based on unvalidated user-input may cause file information disclosure
 *              and uploading files with unvalidated file types to an arbitrary directory may lead to
 *              Remote Command Execution (RCE).
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/file-path-injection
 * @tags security
 *       external/cwe-073
 */

import java
import semmle.code.java.dataflow.FlowSources
import JFinalController
import PathSanitizer
import DataFlow::PathGraph

/**
 * A sink that represents a file read operation.
 */
private class ReadFileSinkModels extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.io;FileInputStream;false;FileInputStream;;;Argument[0];read-file",
        "java.io;File;false;File;;;Argument[0];read-file"
      ]
  }
}

/**
 * A sink that represents a file creation or access, such as a file read, write, copy or move operation.
 */
private class FileAccessSink extends DataFlow::Node {
  FileAccessSink() { sinkNode(this, "create-file") or sinkNode(this, "read-file") }
}

class InjectFilePathConfig extends TaintTracking::Configuration {
  InjectFilePathConfig() { this = "InjectFilePathConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof FileAccessSink }

  override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
    guard instanceof PathTraversalBarrierGuard
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, InjectFilePathConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "External control of file name or path due to $@.",
  source.getNode(), "user-provided value"
