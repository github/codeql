import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

/**
 * Create custom sink to cast in main query
 * This file will hold all configs
 */
class Foo extends DataFlow::Node {
  Foo() { none() }
}
