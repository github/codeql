import semmle.python.dataflow.TaintTracking
private import semmle.python.objects.ObjectInternal
import semmle.python.dataflow.Implementation

/** A configuration that provides backwards compatibility with config-less taint-tracking */
private class LegacyConfiguration extends TaintTracking::Configuration {
  LegacyConfiguration() {
    /* A name that won't be accidentally chosen by users */
    this = "Semmle: Internal legacy configuration"
  }

  override predicate isSource(TaintSource src) { src = src }

  override predicate isSink(TaintSink sink) { sink = sink }

  override predicate isSanitizer(Sanitizer sanitizer) { sanitizer = sanitizer }

  override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node dest) {
    exists(DataFlowExtension::DataFlowNode legacyExtension | src.asCfgNode() = legacyExtension |
      dest.asCfgNode() = legacyExtension.getASuccessorNode()
      or
      dest.asVariable() = legacyExtension.getASuccessorVariable()
      or
      dest.asCfgNode() = legacyExtension.getAReturnSuccessorNode(_)
      or
      dest.asCfgNode() = legacyExtension.getACalleeSuccessorNode(_)
    )
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind
  ) {
    exists(DataFlowExtension::DataFlowNode legacyExtension | src.asCfgNode() = legacyExtension |
      dest.asCfgNode() = legacyExtension.getASuccessorNode(srckind, destkind)
    )
  }

  override predicate isBarrierEdge(DataFlow::Node src, DataFlow::Node dest) {
    (
      exists(DataFlowExtension::DataFlowVariable legacyExtension |
        src.asVariable() = legacyExtension and
        legacyExtension.prunedSuccessor(dest.asVariable())
      )
      or
      exists(DataFlowExtension::DataFlowNode legacyExtension |
        src.asCfgNode() = legacyExtension and
        legacyExtension.prunedSuccessor(dest.asCfgNode())
      )
    )
  }
}
