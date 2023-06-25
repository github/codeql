/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/user-controlled-file-decompression--tar
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import DataFlow::PathGraph
import API
import semmle.javascript.Concepts
import ReadableAdditionalStep
import CommandLineSource

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
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
    source.asExpr() =
      API::moduleImport("tar")
          .getMember(["x", "extract"])
          .getParameter(0)
          .asSink()
          .asExpr()
          .(ObjectExpr)
          .getAChild()
          .(Property)
          .getAChild() and
    not source.getALocalSource().mayHaveStringValue(_)
  }

  override predicate isSink(DataFlow::Node sink) {
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
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
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

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
