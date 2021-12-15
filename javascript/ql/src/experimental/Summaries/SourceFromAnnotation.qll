import javascript
import Shared

/**
 * A data flow node that is annotated as a source.
 */
class SourceFromAnnotation extends DataFlow::AdditionalSource {
  AnnotationComment c;

  SourceFromAnnotation() {
    c.appliesTo(this) and
    c.specifiesSource(_, _)
  }

  override predicate isSourceFor(DataFlow::Configuration cfg, DataFlow::FlowLabel lbl) {
    c.specifiesSource(lbl, cfg)
  }
}
