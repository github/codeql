import javascript
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm

query predicate effectiveSinks(DataFlow::Node node) {
  not exists(NosqlInjectionAtm::SinkEndpointFilter::getAReasonSinkExcluded(node))
}
