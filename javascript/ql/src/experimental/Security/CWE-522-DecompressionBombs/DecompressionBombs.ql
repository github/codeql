/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/user-controlled-data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import javascript
import CommandLineSource
import ReadableAdditionalStep

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) {
    exists(Function f | source.asExpr() = f.getAParameter() |
      not exists(source.getALocalSource().getStringValue())
    )
    or
    source instanceof RemoteFlowSource
    or
    source.asExpr() = any(Parameter cls)
    or
    exists(FileSystemReadAccess fsra | source = fsra.getADataNode() |
      not exists(fsra.getALocalSource().getStringValue())
    )
    or
    exists(API::Node node |
      source = node.getParameter(0).asSink() and
      node = API::moduleImport("adm-zip") and
      not exists(source.getALocalSource().getStringValue())
    )
    or
    exists(AstNode e |
      e =
        API::moduleImport("tar")
            .getMember(["x", "extract"])
            .getParameter(0)
            .asSink()
            .asExpr()
            .(ObjectExpr)
            .getAChild()
            .(Property)
    |
      source.asExpr() = e.getAChild() and
      e.getAChild*().(Label).getName() = "file" and
      not source.getALocalSource().mayHaveStringValue(_)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    // jszip
    exists(API::Node loadAsync | loadAsync = API::moduleImport("jszip").getMember("loadAsync") |
      sink = loadAsync.getParameter(0).asSink() and jsZipsanitizer(loadAsync)
    )
    or
    // node-tar
    exists(API::Node tarExtract |
      tarExtract = API::moduleImport("tar").getMember(["x", "extract"])
    |
      (
        // piping tar.x()
        sink = tarExtract.getACall()
        or
        // tar.x({file: filename})
        // and we don't have a  "maxReadSize: ANum" option
        sink.asExpr() =
          tarExtract
              .getParameter(0)
              .asSink()
              .asExpr()
              .(ObjectExpr)
              .getAChild()
              .(Property)
              .getAChild*() and
        tarExtract
            .getParameter(0)
            .asSink()
            .asExpr()
            .(ObjectExpr)
            .getAChild()
            .(Property)
            .getAChild*()
            .(Label)
            .getName() = "file"
      ) and
      nodeTarSanitizer(tarExtract)
    )
    or
    // zlib
    // we don't have a "maxOutputLength: ANum" option
    exists(API::Node zlib |
      zlib =
        API::moduleImport("zlib")
            .getMember([
                "createGunzip", "createBrotliDecompress", "createUnzip", "createInflate",
                "createInflateRaw"
              ]) and
      sink = zlib.getACall() and
      zlibSanitizer(zlib, 0)
      or
      zlib =
        API::moduleImport("zlib")
            .getMember([
                "gunzip", "gunzipSync", "unzip", "unzipSync", "brotliDecompress",
                "brotliDecompressSync", "inflateSync", "inflateRawSync", "inflate", "inflateRaw"
              ]) and
      sink = zlib.getACall().getArgument(0) and
      zlibSanitizer(zlib, 1)
    )
    or
    // pako
    sink =
      DataFlow::moduleMember("pako", ["inflate", "inflateRaw", "ungzip"]).getACall().getArgument(0)
    or
    // adm-zip
    exists(API::Node n | n = API::moduleImport("adm-zip").getInstance() |
      (
        sink = n.getMember(["extractAllTo", "extractEntryTo", "readAsText"]).getReturn().asSource()
        or
        sink =
          n.getMember("getEntries").getASuccessor*().getMember("getData").getReturn().asSource()
      )
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // additional taint step for fs.readFile(pred)
    // It can be global additional step too
    exists(DataFlow::CallNode n | n = DataFlow::moduleMember("fs", "readFile").getACall() |
      pred = n.getArgument(0) and succ = n.getABoundCallbackParameter(1, 1)
    )
    or
    //node-tar
    readablePipeAdditionalTaintStep(pred, succ)
    or
    exists(FileSystemReadAccess cn | pred = cn.getADataNode() and succ = cn.getAPathArgument())
    or
    exists(DataFlow::Node sinkhelper, AstNode an |
      an = sinkhelper.asExpr().(ObjectExpr).getAChild().(Property).getAChild()
    |
      pred.asExpr() = an and
      succ = sinkhelper
    )
    or
    exists(API::Node n | n = API::moduleImport("tar") |
      pred = n.asSource() and
      (
        succ = n.getMember("x").getACall() or
        succ = n.getMember("x").getACall().getArgument(0)
      )
    )
    or
    // pako
    // succ = new Uint8Array(pred)
    exists(DataFlow::Node n, NewExpr ne | ne = n.asExpr() |
      pred.asExpr() = ne.getArgument(0) and
      succ.asExpr() = ne and
      ne.getCalleeName() = "Uint8Array"
    )
    or
    // AdmZip
    exists(API::Node n | n = API::moduleImport("adm-zip") |
      pred = n.getParameter(0).asSink() and
      (
        succ =
          n.getInstance()
              .getMember(["extractAllTo", "extractEntryTo", "readAsText"])
              .getReturn()
              .asSource() or
        succ =
          n.getInstance()
              .getMember("getEntries")
              .getASuccessor*()
              .getMember("getData")
              .getReturn()
              .asSource()
      )
    )
    or
    // pred.pipe(succ)
    // I saw many instances like response.pipe(succ) which I couldn't exactly model this pattern
    exists(DataFlow::MethodCallNode n |
      n.getMethodName() = "pipe" and
      succ = n.getArgument(0) and
      pred = n.getReceiver() and
      not pred instanceof DataFlow::MethodCallNode
    )
  }
}

predicate nodeTarSanitizer(API::Node tarExtract) {
  not tarExtract
      .getParameter(0)
      .asSink()
      .asExpr()
      .(ObjectExpr)
      .getAChild()
      .(Property)
      .getAChild*()
      .(Label)
      .getName() = "maxReadSize"
}

predicate jsZipsanitizer(API::Node loadAsync) {
  not exists(loadAsync.getASuccessor*().getMember("_data").getMember("uncompressedSize"))
}

predicate zlibSanitizer(API::Node zlib, int numOfParameter) {
  numOfParameter = [0, 1] and
  not zlib.getParameter(numOfParameter)
      .asSink()
      .asExpr()
      .(ObjectExpr)
      .getAChild()
      .(Property)
      .getAChild*()
      .(Label)
      .getName() = "maxOutputLength"
}

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
