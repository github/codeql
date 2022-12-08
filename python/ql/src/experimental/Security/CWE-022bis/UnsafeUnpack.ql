/**
 * @name Arbitrary file write during a remotely downloaded tarball extraction
 * @description Extracting files from a malicious tarball using `shutil.unpack_archive()` without validating
 *              that the destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten. More precisely, if the tarball comes from a remote location.
 * @kind path-problem
 * @id py/unsafe-unpacking
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @tags security
 *       external/cwe/cwe-022
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.ApiGraphs
import DataFlow::PathGraph
import semmle.python.dataflow.new.TaintTracking
import semmle.python.frameworks.Stdlib

class UnsafeUnpackingConfig extends TaintTracking::Configuration {
  UnsafeUnpackingConfig() { this = "UnsafeUnpackingConfig" }

  override predicate isSource(DataFlow::Node source) {
    // A source coming from a remote location
    exists(Http::Client::Request request | source = request)
  }

  override predicate isSink(DataFlow::Node sink) {
    // A sink capturing method calls to `unpack_archive`.
    sink = API::moduleImport("shutil").getMember("unpack_archive").getACall().getArg(0)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    (
      // Writing the response data to the archive
      exists(Stdlib::FileLikeObject::InstanceSource is, Node f, MethodCallNode mc |
        is.flowsTo(f) and
        mc.getMethodName() = "write" and
        f = mc.getObject() and
        nodeFrom = mc.getArg(0) and
        nodeTo = is.(CallCfgNode).getArg(0)
      )
      or
      // Reading the response
      exists(MethodCallNode mc |
        nodeFrom = mc.getObject() and
        mc.getMethodName() = "read" and
        mc.flowsTo(nodeTo)
      )
      or
      // Accessing the name
      exists(AttrRead ar | ar.accesses(nodeFrom, "name") and nodeTo = ar)
      or
      // Considering closing use
      exists(API::Node closing |
        closing = API::moduleImport("contextlib").getMember("closing") and
        closing.getACall().flowsTo(nodeTo) and
        nodeFrom = closing.getACall().getArg(0)
      )
    )
  }
}

from UnsafeUnpackingConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Unsafe extraction from a malicious tarball retrieved from a remote location."
