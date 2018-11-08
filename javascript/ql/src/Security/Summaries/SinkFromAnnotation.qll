import javascript
import Shared

/**
 * A data flow node that is annotated as a sink.
 */
class SinkFromAnnotation extends DataFlow::AdditionalSink {
  AnnotationComment c;

  SinkFromAnnotation() {
    c.appliesTo(this) and
    c.specifiesSink(_, _)
  }

  override predicate isSinkFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    c.specifiesSink(lbl, cfg)
  }
}
