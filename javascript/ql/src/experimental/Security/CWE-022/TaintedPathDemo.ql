/**
 * @name Uncontrolled data used in path expression
 * @description Demo of Accessing paths influenced by users can allow an attacker to access
 *              unexpected resources.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/path-injectiondemo
 * @tags security
 *       external/cwe/cwe-022
 */

import javascript
import DataFlow::PathGraph
import javascript
import DOM
import ReadableAdditionalStep

/**
 * A write to the file system.
 * I can't extends  NodeJSFileSystemAccess
 */
class NodeJSPromisesFileSystemAccessWrite extends FileSystemWriteAccess, DataFlow::Node {
  string methodName;
  API::Node methodNode;

  NodeJSPromisesFileSystemAccessWrite() {
    methodName = ["open", "appendFile", "writeFile", "copyFile"] and
    methodNode = nodeJsPromisesFileSystem().getMember(methodName) and
    this = methodNode.asSource()
  }

  override DataFlow::Node getAPathArgument() { result = methodNode.getParameter(0).asSink() }

  override DataFlow::Node getADataNode() {
    methodName = ["appendFile", "writeFile", "copyFile"] and
    result = methodNode.getParameter(1).asSink()
    or
    methodName = "open" and
    result =
      [
        methodNode
            .getASuccessor*()
            .getMember(["appendFile", "write", "writeFile", "writev"])
            .getParameter(0)
            .asSink(),
        methodNode.getASuccessor*().getMember("write").getASuccessor*().getMember("buffer").asSink(),
        methodNode
            .getASuccessor*()
            .getMember("writev")
            .getASuccessor*()
            .getMember("buffers")
            .asSink()
      ]
  }
}

/**
 * A file system read.
 * I can't extends NodeJSFileSystemAccess
 */
class NodeJSPromisesFileSystemAccessRead extends FileSystemReadAccess, DataFlow::Node {
  string methodName;
  API::Node methodNode;

  NodeJSPromisesFileSystemAccessRead() {
    methodName = ["open", "readdir", "readFile", "readlink"] and
    methodNode = nodeJsPromisesFileSystem().getMember(methodName) and
    this = methodNode.asSource()
  }

  override DataFlow::Node getADataNode() {
    methodName = "open" and
    result =
      [
        methodNode.getASuccessor*().getMember(["read", "readv"]).getParameter(0).asSink(),
        // or the followings
        methodNode
            .getASuccessor*()
            .getMember("read")
            .getReturn()
            .getASuccessor*()
            .getMember("buffer")
            .asSource(),
        methodNode
            .getASuccessor*()
            .getMember("readv")
            .getReturn()
            .getASuccessor*()
            .getMember("buffers")
            .asSource(),
        // readFile returns Buffer Object, idk how to proccess after that ??
        methodNode.getASuccessor*().getMember("readFile").getASuccessor*().asSource()
      ]
    or
    // the return value can be a parameter of promises or return value so I have to use getASuccessor*()
    methodName = ["readdir", "readFile", "readlink"] and
    result = methodNode.getReturn().getASuccessor*().asSource()
  }

  override DataFlow::Node getAPathArgument() { result = methodNode.getParameter(0).asSink() }
}

/**
 * Promises API
 */
API::Node nodeJsPromisesFileSystem() {
  result = [API::moduleImport("fs").getMember("promises"), API::moduleImport("fs/promises")]
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PathTraversal" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(FileSystemReadAccess a).getAPathArgument()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // currently there is a Class named JoinedPath which idk why it it only working with path methods
    // that only their first arg is constant and the number of args are 2 ??
    // also there isn't any additional steps from a SpreadElement childs to SpreadElement itself
    // e.g this CVE-2023-35844 vulnerability was detected because there is a path.join('/tmp',req.params.sth) in its DataFlow Path
    // but this CVE-2023-35843 vulnerability was not detected(of course the fs/promises.readFile sink didn't exist too)
    exists(API::Node n | n = API::moduleImport("path").getMember("join") |
      pred = n.getAParameter().asSink() and
      succ = n.getReturn().asSource()
      // It is really wierd that I cant get second arg of pat.join in following
      // `path.join("a/", ...filePath.split('/'))`
      // with API::moduleImport("path").getMember("join").getAParameter()
      // note that if there was filepath instead of second arg I could get the second parameter
      // so I'm using following exists instead of using of API graphs
    )
    or
    exists(MethodCallExpr call, VarAccess receiver | receiver = call.getReceiver().(VarAccess) |
      receiver.getName() = "path" and
      call.getMethodName() = "join" and
      pred.asExpr() = call.getAnArgument() and
      succ.asExpr() = receiver
    )
    or
    // succ = filePath.split('/')
    // pred = filePath
    exists(DataFlow::MethodCallNode method |
      method.getMethodName() = "split" and
      pred = method.getReceiver() and
      succ = method
    )
    or
    // // succ = ...aMethodCall
    // // pred = aMethodCall
    exists(SpreadElement spread |
      succ.asExpr() = spread and
      pred.asExpr() = any(Expr e | e = spread.getAChild*() and not e instanceof Literal)
    )
    or
    // https://www.npmjs.com/package/slash 65M d/w :))
    // it exists in the DataFlow Path of related CVE
    exists(DataFlow::CallNode slash | slash = DataFlow::moduleImport("slash").getACall() |
      pred = slash.getArgument(0) and
      succ = slash
    )
    or
    promisesFileHandlePipeAdditionalTaintStep(pred, succ)
    or
    streamPipelineAdditionalTaintStep(pred, succ)
    or
    readablePipeAdditionalTaintStep(pred, succ)
  }
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This path depends on a $@.", source.getNode(),
  "user-provided value"
