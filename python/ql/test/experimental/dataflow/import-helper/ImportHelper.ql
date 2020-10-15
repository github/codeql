import python
import experimental.dataflow.DataFlow

query predicate importModule(DataFlow::Node res, string name) { res = DataFlow::importModule(name) }

query predicate importMember(DataFlow::Node res, string moduleName, string memberName) {
  res = DataFlow::importMember(moduleName, memberName)
}
