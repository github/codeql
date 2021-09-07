import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.DataFlow2
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.TaintTracking2
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.security.dataflow.ChainedConfigs12
import experimental.semmle.python.Concepts
import semmle.python.Concepts

/**
 * A taint-tracking configuration for detecting string-to-dict conversions.
 */
class RFSToDictConfig extends TaintTracking::Configuration {
  RFSToDictConfig() { this = "RFSToDictConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(Decoding decoding | decoding.getFormat() = "JSON" and sink = decoding.getOutput())
  }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getAnInput()
  }
}

/**
 * A taint-tracking configuration for detecting NoSQL injections (previously converted to a dict).
 */
class FromDataDictToSink extends TaintTracking2::Configuration {
  FromDataDictToSink() { this = "FromDataDictToSink" }

  override predicate isSource(DataFlow::Node source) {
    exists(Decoding decoding | decoding.getFormat() = "JSON" and source = decoding.getOutput())
  }

  override predicate isSink(DataFlow::Node sink) { sink = any(NoSQLQuery noSQLQuery).getQuery() }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer = any(NoSQLSanitizer noSQLSanitizer).getAnInput()
  }
}

/**
 * A predicate checking string-to-dict conversion and its arrival to a NoSQL injection sink.
 */
predicate noSQLInjectionFlow(CustomPathNode source, CustomPathNode sink) {
  exists(
    RFSToDictConfig config, DataFlow::PathNode mid1, DataFlow2::PathNode mid2,
    FromDataDictToSink config2
  |
    config.hasFlowPath(source.asNode1(), mid1) and
    config2.hasFlowPath(mid2, sink.asNode2()) and
    mid1.getNode().asCfgNode() = mid2.getNode().asCfgNode()
  )
}
