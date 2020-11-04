import python
import semmle.python.dataflow.new.DataFlow

query predicate importNode(DataFlow::Node res, string name) { res = DataFlow::importNode(name) }
