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
import ReadableAdditionalStep
import DataFlow::PathGraph

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    // jszip
    exists(API::Node loadAsync | loadAsync = API::moduleImport("jszip").getMember("loadAsync") |
      sink = loadAsync.getParameter(0).asSink() and not jsZipsanitizer(loadAsync)
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
        sink = tarExtract.getParameter(0).getMember("file").asSink()
        or
        // tar.x({file: filename})
        sink = tarExtract.getParameter(0).getMember("file").asSink()
      ) and
      // and there shouldn't be a  "maxReadSize: ANum" option
      not nodeTarSanitizer(tarExtract)
    )
    or
    // zlib
    // there shouldn't be a "maxOutputLength: ANumber" option
    exists(API::Node zlib |
      zlib =
        API::moduleImport("zlib")
            .getMember([
                "createGunzip", "createBrotliDecompress", "createUnzip", "createInflate",
                "createInflateRaw"
              ]) and
      sink = zlib.getACall() and
      not zlibSanitizer(zlib.getParameter(0))
      or
      zlib =
        API::moduleImport("zlib")
            .getMember([
                "gunzip", "gunzipSync", "unzip", "unzipSync", "brotliDecompress",
                "brotliDecompressSync", "inflateSync", "inflateRawSync", "inflate", "inflateRaw"
              ]) and
      sink = zlib.getACall().getArgument(0) and
      not zlibSanitizer(zlib.getParameter(1))
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
    streamPipelineAdditionalTaintStep(pred, succ)
    or
    promisesFileHandlePipeAdditionalTaintStep(pred, succ)
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
    exists(DataFlow::MethodCallNode n |
      n.getMethodName() = "pipe" and
      succ = n.getArgument(0) and
      pred = n.getReceiver() and
      not pred instanceof DataFlow::MethodCallNode
    )
  }
}

predicate nodeTarSanitizer(API::Node tarExtract) {
  exists(tarExtract.getParameter(0).getMember("maxReadSize"))
}

predicate jsZipsanitizer(API::Node loadAsync) {
  exists(loadAsync.getASuccessor*().getMember("_data").getMember("uncompressedSize"))
}

predicate zlibSanitizer(API::Node zlib) { exists(zlib.getMember("maxOutputLength")) }

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
