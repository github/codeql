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

/**
 * Handle those three cases of Tarfile opens:
 *  - `tarfile.open()`
 *  - `tarfile.TarFile()`
 *  - `MKtarfile.Tarfile.open()`
 */
API::Node tarfileOpen() {
  result in [
      API::moduleImport("tarfile").getMember(["open", "TarFile"]),
      API::moduleImport("tarfile").getMember("TarFile").getASubclass().getMember("open")
    ]
}

/**
 * A class for handling the previous three cases, plus the use of `closing` in with the previous cases
 */
class AllTarfileOpens extends API::CallNode {
  AllTarfileOpens() {
    this = tarfileOpen().getACall()
    or
    exists(API::Node closing, Node arg |
      closing = API::moduleImport("contextlib").getMember("closing") and
      this = closing.getACall() and
      arg = this.getArg(0) and
      arg = tarfileOpen().getACall()
    )
  }
}

module UnsafeUnpackConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
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
    // A source catching an S3 file download
    // see boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.download_file
    source =
      API::moduleImport("boto3")
          .getMember("client")
          .getReturn()
          .getMember(["download_file", "download_fileobj"])
          .getACall()
          .getArg(2)
    or
    // A source catching an S3 file download
    // see boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/core/session.html
    source =
      API::moduleImport("boto3")
          .getMember("Session")
          .getReturn()
          .getMember("client")
          .getReturn()
          .getMember(["download_file", "download_fileobj"])
          .getACall()
          .getArg(2)
    or
    // A source download a file using wget
    // see wget: https://pypi.org/project/wget/
    exists(API::CallNode mcn |
      mcn = API::moduleImport("wget").getMember("download").getACall() and
      if exists(mcn.getArg(1)) then source = mcn.getArg(1) else source = mcn.getReturn().asSource()
    )
    or
    // catch the Django uploaded files as a source
    // see HttpRequest.FILES: https://docs.djangoproject.com/en/4.1/ref/request-response/#django.http.HttpRequest.FILES
    source.(AttrRead).getAttributeName() = "FILES"
  }

  predicate isSink(DataFlow::Node sink) {
    (
      // A sink capturing method calls to `unpack_archive`.
      sink = API::moduleImport("shutil").getMember("unpack_archive").getACall().getArg(0)
      or
      // A sink capturing method calls to `extractall` without `members` argument.
      // For a call to `file.extractall` without `members` argument, `file` is considered a sink.
      exists(MethodCallNode call, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("extractall").getACall() and
        not exists(call.getArgByName("members")) and
        sink = call.getObject()
      )
      or
      // A sink capturing method calls to `extractall` with `members` argument.
      // For a call to `file.extractall` with `members` argument, `file` is considered a sink if not
      // a the `members` argument contains a NameConstant as None, a List or call to the method `getmembers`.
      // Otherwise, the argument of `members` is considered a sink.
      exists(MethodCallNode call, Node arg, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("extractall").getACall() and
        arg = call.getArgByName("members") and
        if
          arg.asCfgNode() instanceof NameConstantNode or
          arg.asCfgNode() instanceof ListNode
        then sink = call.getObject()
        else
          if arg.(MethodCallNode).getMethodName() = "getmembers"
          then sink = arg.(MethodCallNode).getObject()
          else sink = call.getArgByName("members")
      )
      or
      // An argument to `extract` is considered a sink.
      exists(AllTarfileOpens atfo |
        sink = atfo.getReturn().getMember("extract").getACall().getArg(0)
      )
      or
      //An argument to `_extract_member` is considered a sink.
      exists(MethodCallNode call, AllTarfileOpens atfo |
        call = atfo.getReturn().getMember("_extract_member").getACall() and
        call.getArg(1).(AttrRead).accesses(sink, "name")
      )
    ) and
    not sink.getScope().getLocation().getFile().inStdlib()
  }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    // Reading the response
    nodeTo.(MethodCallNode).calls(nodeFrom, "read")
    or
    // Open a file for access
    exists(MethodCallNode cn |
      cn.calls(nodeTo, "open") and
      cn.flowsTo(nodeFrom)
    )
    or
    // Open a file for access using builtin
    exists(API::CallNode cn |
      cn = API::builtin("open").getACall() and
      nodeTo = cn.getArg(0) and
      cn.flowsTo(nodeFrom)
    )
    or
    // Write access
    exists(MethodCallNode cn |
      cn.calls(nodeTo, "write") and
      nodeFrom = cn.getArg(0)
    )
    or
    // Retrieve Django uploaded files
    // see getlist(): https://docs.djangoproject.com/en/4.1/ref/request-response/#django.http.QueryDict.getlist
    // see chunks(): https://docs.djangoproject.com/en/4.1/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile.chunks
    nodeTo.(MethodCallNode).calls(nodeFrom, ["getlist", "get", "chunks"])
    or
    // Considering the use of "fs"
    // see fs: https://docs.djangoproject.com/en/4.1/ref/files/storage/#the-filesystemstorage-class
    nodeTo =
      API::moduleImport("django")
          .getMember("core")
          .getMember("files")
          .getMember("storage")
          .getMember("FileSystemStorage")
          .getReturn()
          .getMember(["save", "path"])
          .getACall() and
    nodeFrom = nodeTo.(MethodCallNode).getArg(0)
    or
    // Accessing the name or raw content
    nodeTo.(AttrRead).accesses(nodeFrom, ["name", "raw"])
    or
    // Join the base_dir to the filename
    nodeTo = API::moduleImport("os").getMember("path").getMember("join").getACall() and
    nodeFrom = nodeTo.(API::CallNode).getArg(1)
    or
    // Go through an Open for a Tarfile
    nodeTo = tarfileOpen().getACall() and nodeFrom = nodeTo.(MethodCallNode).getArg(0)
    or
    // Handle the case where the getmembers is used.
    nodeTo.(MethodCallNode).calls(nodeFrom, "getmembers") and
    nodeFrom instanceof AllTarfileOpens
    or
    // To handle the case of `with closing(tarfile.open()) as file:`
    // we add a step from the first argument of `closing` to the call to `closing`,
    // whenever that first argument is a return of `tarfile.open()`.
    nodeTo = API::moduleImport("contextlib").getMember("closing").getACall() and
    nodeFrom = nodeTo.(API::CallNode).getArg(0) and
    nodeFrom = tarfileOpen().getReturn().getAValueReachableFromSource()
    or
    // see Path : https://docs.python.org/3/library/pathlib.html#pathlib.Path
    nodeTo = API::moduleImport("pathlib").getMember("Path").getACall() and
    nodeFrom = nodeTo.(API::CallNode).getArg(0)
    or
    // Use of absolutepath
    // see absolute : https://docs.python.org/3/library/pathlib.html#pathlib.Path.absolute
    exists(API::CallNode mcn |
      mcn = API::moduleImport("pathlib").getMember("Path").getACall() and
      nodeTo = mcn.getAMethodCall("absolute") and
      nodeFrom = mcn.getArg(0)
    )
  }
}

/** Global taint-tracking for detecting "UnsafeUnpacking" vulnerabilities. */
module UnsafeUnpackFlow = TaintTracking::Global<UnsafeUnpackConfig>;
