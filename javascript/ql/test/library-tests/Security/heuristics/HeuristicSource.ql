import javascript
private import semmle.javascript.heuristics.AdditionalSources
import testUtilities.ConsistencyChecking

class Taint extends TaintTracking::Configuration {
  Taint() { this = "Taint" }

  override predicate isSource(DataFlow::Node node) { node instanceof HeuristicSource }

  override predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
  }
}
