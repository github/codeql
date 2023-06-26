/**
 * @id javascript/sequlize
 * @kind path-problem
 * @name demonstrate sequlize additional taint step for findByPk method
 * @description add sequlize methods calls on custom models as sinks and additional taint steps
 * @problem.severity error
 * @precision low
 * @tags experimental
 */

import javascript
import DataFlow::PathGraph
import sequelizeModelTypes::SequelizeModel
import API

class SequelizeModelConfiguration extends TaintTracking::Configuration {
  SequelizeModelConfiguration() { this = "Bombs" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    exists(source.getTopLevel().getFile().getRelativePath())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode n |
      n.getCalleeName() = "findByPk" and
      sequelizeModelAsSourceNode().(DataFlow::LocalSourceNode).flowsTo(n.getReceiver()) and
      sink = n.getArgument(0)
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode n |
      // any related method of sequelize can be added here
      n.getCalleeName() = "findByPk" and
      sequelizeModelAsSourceNode().(DataFlow::LocalSourceNode).flowsTo(n.getReceiver()) and
      pred = n.getArgument(0) and
      succ = n
    )
    or
    // succ = { pred : pred} I think it has high FP rate for be a global taint step!
    exists(DataFlow::Node sinkhelper, AstNode an |
      an = sinkhelper.asExpr().(ObjectExpr).getAChild().(Property).getAChild()
    |
      pred.asExpr() = an and
      succ = sinkhelper
    )
  }
}

from SequelizeModelConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "from ==> to"
