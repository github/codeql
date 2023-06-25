/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/user-controlled-file-decompression-zlib-pako-admzip
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import javascript
import DataFlow::PathGraph
import API
import semmle.javascript.security.dataflow.IndirectCommandInjectionCustomizations
import ReadableAdditionalStep
import CommandLineSource

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) {
    source = any(RemoteFlowSource rfs)
    or
    // cli Sources
    source = any(CommandLineFlowSource cls).asSource()
    or
    exists(Function f | source.asExpr() = f.getAParameter() |
      not exists(source.getALocalSource().getStringValue())
    )
    or
    exists(FileSystemReadAccess fsra | source = fsra.getADataNode() |
      not exists(fsra.getALocalSource().getStringValue())
    )
    or
    exists(DataFlow::NewNode nn, DataFlow::Node n | nn = n.(NewNode) |
      source = nn.getArgument(0) and
      nn.getCalleeName() = "AdmZip" and
      not exists(source.getALocalSource().getStringValue())
    )
  }

  override predicate isSink(DataFlow::Node sink) {
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
    sink =
      DataFlow::moduleMember("pako", ["inflate", "inflateRaw", "ungzip"]).getACall().getArgument(0)
    or
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
    readablePipeAdditionalTaintStep(pred, succ)
    or
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
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
