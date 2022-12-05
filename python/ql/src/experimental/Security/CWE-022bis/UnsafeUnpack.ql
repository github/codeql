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
 *       external/cwe/cwe-022bis
 */

import python
import experimental.semmle.python.Concepts
import DataFlow::PathGraph
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.Attributes
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.Concepts

class UnsafeUnpackingConfig extends TaintTracking::Configuration {
  UnsafeUnpackingConfig() { this = "UnsafeUnpackingConfig" }

  override predicate isSource(DataFlow::Node source) {
    // A source coming from a remote location
    exists(Http::Client::Request request | source = request) and
    not source.getScope().getLocation().getFile().inStdlib()
  }

  override predicate isSink(DataFlow::Node sink) {
    // A sink capturing method calls to `unpack_archive`.
    sink =
      API::moduleImport("shutil").getMember("unpack_archive").getACall().getParameter(0).asSink() and
    not sink.getScope().getLocation().getFile().inStdlib()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Writing the response data to the archive
    exists(API::CallNode call, MethodCallNode w |
      nodeTo = call.getArg(0) and
      call = API::builtin("open").getACall() and
      w.getMethodName() = "write" and
      w.getObject() = call.getReturn().getAValueReachableFromSource() and
      nodeFrom = w.getArg(0)
    )
  }
}

from UnsafeUnpackingConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Unsafe extraction from a malicious tarball, is used in a $@",
  source.getAQlClass(), "during archive unpacking."