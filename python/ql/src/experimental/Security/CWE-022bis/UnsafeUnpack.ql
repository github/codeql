/**
 * @name Arbitrary file write during a tarball extraction from a user controlled source
 * @description Extracting files from a potentially malicious tarball using `shutil.unpack_archive()` without validating
 *              that the destination file path is within the destination directory can cause files outside
 *              the destination directory to be overwritten. More precisely, if the tarball comes from a user controlled
 *              location either a remote one or cli argument.
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
    or
    // A source coming from a CLI argparse module
    // see argparse: https://docs.python.org/3/library/argparse.html
    exists(MethodCallNode args |
      args = source.(AttrRead).getObject().getALocalSource() and
      args =
        API::moduleImport("argparse")
            .getMember("ArgumentParser")
            .getACall()
            .getReturn()
            .getMember("parse_args")
            .getACall()
    )
    or
    // A source catching an S3 filename download
    // see boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.download_file
    exists(MethodCallNode mcn, Node s3, Node bc |
      bc = API::moduleImport("boto3").getMember("client").getACall() and
      bc = s3.getALocalSource() and
      mcn.calls(s3, "download_file") and
      source = mcn.getArg(2)
    )
    or
    // A source download a file using wget
    // see wget: https://pypi.org/project/wget/
    exists(API::CallNode mcn |
      mcn = API::moduleImport("wget").getMember("download").getACall() and
      (
        source = mcn.getArg(1)
        or
        source = mcn.getReturn().asSource() and not exists(Node arg | arg = mcn.getArg(1))
      )
    )
    or
    // catch the uploaded files as a source
    exists(Subscript s, Attribute at |
      at = s.getObject() and at.getAttr() = "FILES" and source.asExpr() = s
    )
    or
    exists(Node obj, AttrRead ar |
      ar.getAMethodCall("get").flowsTo(source) and
      ar.accesses(obj, "FILES")
    )
    or
    exists(Node obj, AttrRead ar |
      ar.getAMethodCall("getlist").flowsTo(source) and
      ar.accesses(obj, "FILES")
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    // A sink capturing method calls to `unpack_archive`.
    sink = API::moduleImport("shutil").getMember("unpack_archive").getACall().getArg(0)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Writing the response data to the archive
    exists(Stdlib::FileLikeObject::InstanceSource is, Node f, MethodCallNode mc |
      is.flowsTo(f) and
      mc.calls(f, "write") and
      nodeFrom = mc.getArg(0) and
      nodeTo = is.(CallCfgNode).getArg(0)
    )
    or
    // Copying the response data to the archive
    exists(Stdlib::FileLikeObject::InstanceSource is, Node f, MethodCallNode mc |
      is.flowsTo(f) and
      mc = API::moduleImport("shutil").getMember("copyfileobj").getACall() and
      f = mc.getArg(1) and
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
    // Accessing the name or raw content
    exists(AttrRead ar | ar.accesses(nodeFrom, ["name", "raw"]) and ar.flowsTo(nodeTo))
    or
    //Use of join of filename
    exists(API::CallNode mcn |
      mcn = API::moduleImport("os").getMember("path").getMember("join").getACall() and
      nodeFrom = mcn.getArg(1) and
      mcn.flowsTo(nodeTo)
    )
    or
    // Read by chunks
    exists(MethodCallNode mc |
      nodeFrom = mc.getObject() and mc.getMethodName() = "chunks" and mc.flowsTo(nodeTo)
    )
    or
    // Considering the use of closing()
    exists(API::CallNode closing |
      closing = API::moduleImport("contextlib").getMember("closing").getACall() and
      closing.flowsTo(nodeTo) and
      nodeFrom = closing.getArg(0)
    )
    or
    // Considering the use of "fs"
    exists(API::CallNode fs, MethodCallNode mcn |
      fs =
        API::moduleImport("django")
            .getMember("core")
            .getMember("files")
            .getMember("storage")
            .getMember("FileSystemStorage")
            .getACall() and
      fs.flowsTo(mcn.getObject()) and
      mcn.getMethodName() = ["save", "path"] and
      nodeFrom = mcn.getArg(0) and
      nodeTo = mcn
    )
  }
}

from UnsafeUnpackingConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Unsafe extraction from a malicious tarball retrieved from a remote location."
