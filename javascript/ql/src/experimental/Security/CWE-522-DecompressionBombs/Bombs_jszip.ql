/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import javascript
import CommandLineSource

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
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
    exists(Function f | source.asExpr() = f.getAParameter() |
      not exists(source.getALocalSource().getStringValue())
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(API::Node loadAsync | loadAsync = API::moduleImport("jszip").getMember("loadAsync") |
      sink = loadAsync.getParameter(0).asSink() and sanitizer(loadAsync)
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    // additional taint step for fs.readFile(pred)
    // It can be global additional step too
    exists(DataFlow::CallNode n | n = DataFlow::moduleMember("fs", "readFile").getACall() |
      pred = n.getArgument(0) and succ = n.getABoundCallbackParameter(1, 1)
    )
  }
}

predicate sanitizer(API::Node loadAsync) {
  not exists(loadAsync.getASuccessor*().getMember("_data").getMember("uncompressedSize"))
}

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
