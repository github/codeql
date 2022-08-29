/**
 * Provides a taint tracking configuration for reasoning about
 * tainted-path vulnerabilities coming from library inputs.
 *
 * Note, for performance reasons: only import this file if
 * `TaintedPathFromLibraryInput::Configuration` is needed,
 * otherwise `TaintedPathFromLibraryCustomizations` should
 * be imported instead.
 */

import javascript
import TaintedPathFromLibraryInputCustomizations

// Materialize flow labels
private class ConcretePosixPath extends TaintedPath::Label::PosixPath {
  ConcretePosixPath() { this = this }
}

private class ConcreteSplitPath extends TaintedPath::Label::SplitPath {
  ConcreteSplitPath() { this = this }
}

/**
 * A taint-tracking configuration for reasoning about tainted-path vulnerabilities that
 * come from library inputs.
 */
class Configuration extends DataFlow::Configuration {
  Configuration() { this = "TaintedPathFromLibraryInput" }

  override predicate isSource(DataFlow::Node source, DataFlow::FlowLabel label) {
    // only using library inputs as source
    label = source.(LibInputAsSource).getAFlowLabel()
  }

  override predicate isSink(DataFlow::Node sink, DataFlow::FlowLabel label) {
    sink instanceof StringConcatLeafEndingInSink and exists(label)
  }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof TaintedPath::Sanitizer
  }

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof TaintedPath::BarrierGuardNode
  }

  override predicate isAdditionalFlowStep(
    DataFlow::Node src, DataFlow::Node dst, DataFlow::FlowLabel srclabel,
    DataFlow::FlowLabel dstlabel
  ) {
    TaintedPath::isAdditionalTaintedPathFlowStep(src, dst, srclabel, dstlabel)
  }

  // override to require that there is a path without unmatched return steps
  override predicate hasFlowPath(DataFlow::SourcePathNode source, DataFlow::SinkPathNode sink) {
    super.hasFlowPath(source, sink) and
    DataFlow::hasPathWithoutUnmatchedReturn(source, sink)
  }
}
