/**
 *  Provides a taint-tracking configuration for detecting "UnsafeUnpacking" vulnerabilities.
 */

import python
import semmle.python.Concepts
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.frameworks.Stdlib
import semmle.python.dataflow.new.RemoteFlowSources

class UnsafeUnpackingConfig extends TaintTracking::Configuration {
  UnsafeUnpackingConfig() { this = "UnsafeUnpackingConfig" }

  override predicate isSource(DataFlow::Node source) {
    // A source coming from a remote location
    source instanceof RemoteFlowSource
    or
    // A source coming from a CLI argparse module
    // see argparse: https://docs.python.org/3/library/argparse.html
    exists(MethodCallNode args |
      args = source.(AttrRead).getObject().getALocalSource() and
      args =
        API::moduleImport("argparse")
            .getMember("ArgumentParser")
            .getReturn()
            .getMember("parse_args")
            .getACall()
    )
    or
    // A source catching an S3 filename download
    // see boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.download_file
    source =
      API::moduleImport("boto3")
          .getMember("client")
          .getReturn()
          .getMember("download_file")
          .getACall()
          .getArg(2)
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
    // catch the Django uploaded files as a source
    // see HttpRequest.FILES: https://docs.djangoproject.com/en/4.1/ref/request-response/#django.http.HttpRequest.FILES
    source.(AttrRead).getAttributeName() = "FILES"
  }

  override predicate isSink(DataFlow::Node sink) {
    // A sink capturing method calls to `unpack_archive`.
    sink = API::moduleImport("shutil").getMember("unpack_archive").getACall().getArg(0)
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Open for access
    exists(MethodCallNode cn |
      nodeTo = cn.getObject() and
      cn.getMethodName() = "open" and
      cn.flowsTo(nodeFrom)
    )
    or
    // Write for access
    exists(MethodCallNode cn |
      cn.calls(nodeFrom, "write") and
      nodeTo = cn.getArg(0)
    )
    or
    // Retrieve Django uploaded files
    // see getlist(): https://docs.djangoproject.com/en/4.1/ref/request-response/#django.http.QueryDict.getlist
    // see chunks(): https://docs.djangoproject.com/en/4.1/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile.chunks
    nodeTo.(MethodCallNode).calls(nodeFrom, ["getlist", "get", "chunks"])
    or
    // Reading the response
    nodeTo.(MethodCallNode).calls(nodeFrom, "read")
    or
    // Accessing the name or raw content
    nodeTo.(AttrRead).accesses(nodeFrom, ["name", "raw"])
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
    or
    //Use of join of filename
    nodeTo = API::moduleImport("os").getMember("path").getMember("join").getACall() and
    nodeFrom = nodeTo.(API::CallNode).getArg(1)
    or
    // Write access
    exists(MethodCallNode cn |
      cn.calls(nodeTo, "write") and
      nodeFrom = cn.getArg(0)
    )
    or
    // Writing the response data to the archive
    exists(Stdlib::FileLikeObject::InstanceSource is, Node f, MethodCallNode mc |
      is.flowsTo(f) and
      mc.calls(f, "write") and
      nodeFrom = mc.getArg(0) and
      nodeTo = is.(CallCfgNode).getArg(0)
    )
  }
}
