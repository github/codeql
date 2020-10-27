import python
import experimental.dataflow.DataFlow

query predicate importNode(DataFlow::Node res, string name) { res = DataFlow::importNode(name) }
