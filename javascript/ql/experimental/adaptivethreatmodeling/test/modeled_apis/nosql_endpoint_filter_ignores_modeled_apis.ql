import javascript
import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionATM

query predicate effectiveSinks(DataFlow::Node node) {
  not exists(NosqlInjectionATM::SinkEndpointFilter::getAReasonSinkExcluded(node))
}
