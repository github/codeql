import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.ApiGraphs

query predicate importNode(DataFlow::CfgNode res, string name) {
  res = API::moduleImport(name).getAUse()
}
