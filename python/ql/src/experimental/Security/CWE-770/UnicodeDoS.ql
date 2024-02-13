/**
 * @name Denial of Service using Unicode Characters
 * @description A remote user-controlled data can reach a costly Unicode normalization with either form NFKC or NFKD. On Windows OS, with an attack such as the One Million Unicode Characters, this could lead to a denial of service. And, with the use of special Unicode characters, like U+2100 (℀) or U+2105 (℅), the payload size could be tripled.
 * @kind path-problem
 * @id py/unicode-dos
 * @precision high
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-770
 */

import python
import semmle.python.ApiGraphs
import semmle.python.Concepts
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.dataflow.new.RemoteFlowSources

class UnicodeCompatibilityNormalize extends API::CallNode {
  int argIdx;

  UnicodeCompatibilityNormalize() {
    exists(API::CallNode cn, DataFlow::Node form |
      cn = API::moduleImport("unicodedata").getMember("normalize").getACall() and
      form.asExpr().(StrConst).getS() in ["NFKC", "NFKD"] and
      TaintTracking::localTaint(form, cn.getArg(0)) and
      this = cn and
      argIdx = 1
    )
    or
    exists(API::CallNode cn |
      cn = API::moduleImport("unidecode").getMember("unidecode").getACall() and
      this = cn and
      argIdx = 0
    )
    or
    exists(API::CallNode cn |
      cn = API::moduleImport("pyunormalize").getMember(["NFKC", "NFKD"]).getACall() and
      this = cn and
      argIdx = 0
    )
    or
    exists(API::CallNode cn, DataFlow::Node form |
      cn = API::moduleImport("pyunormalize").getMember("normalize").getACall() and
      form.asExpr().(StrConst).getS() in ["NFKC", "NFKD"] and
      TaintTracking::localTaint(form, cn.getArg(0)) and
      this = cn and
      argIdx = 1
    )
    or
    exists(API::CallNode cn, DataFlow::Node form |
      cn = API::moduleImport("textnorm").getMember("normalize_unicode").getACall() and
      form.asExpr().(StrConst).getS() in ["NFKC", "NFKD"] and
      TaintTracking::localTaint(form, cn.getArg(1)) and
      this = cn and
      argIdx = 0
    )
  }

  DataFlow::Node getPathArg() { result = this.getArg(argIdx) }
}

predicate underAValue(DataFlow::GuardNode g, ControlFlowNode node, boolean branch) {
  exists(CompareNode cn | cn = g |
    exists(API::CallNode lenCall, Cmpop op_gt, Cmpop op_lt, Node n |
      lenCall = n.getALocalSource() and
      (
        (op_lt = any(LtE lte) or op_lt = any(Lt lt)) and
        branch = true and
        cn.operands(n.asCfgNode(), op_lt, _)
        or
        (op_gt = any(GtE gte) or op_gt = any(Gt gt)) and
        branch = true and
        cn.operands(_, op_gt, n.asCfgNode())
      )
    |
      lenCall = API::builtin("len").getACall() and
      node = lenCall.getArg(0).asCfgNode()
    ) //and
    //not cn.getLocation().getFile().inStdlib()
  )
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "RemoteSourcesReachUnicodeCharacters" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = DataFlow::BarrierGuard<underAValue/3>::getABarrierNode()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(UnicodeCompatibilityNormalize ucn).getPathArg()
    or
    sink = API::moduleImport("werkzeug").getMember("secure_filename").getACall().getArg(_)
    or
    sink =
      API::moduleImport("werkzeug")
          .getMember("utils")
          .getMember("secure_filename")
          .getACall()
          .getArg(_)
  
  }
}

import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This $@ can reach a $@.", source.getNode(),
  "user-provided value", sink.getNode(), "costly Unicode normalization operation"
