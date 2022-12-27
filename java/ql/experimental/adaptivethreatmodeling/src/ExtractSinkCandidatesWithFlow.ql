/**
 * Surfaces the endpoints that pass the endpoint filters and have flow from a source for each query config, and are
 * therefore used as candidates for classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Sink candidates with flow (experimental)
 * @description Sink candidates with flow from a source
 * @kind problem
 * @id java/ml-powered/sink-candidates-with-flow
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
// private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm

// private import experimental.adaptivethreatmodeling.XssATM as XssAtm
// private import experimental.adaptivethreatmodeling.XssThroughDomATM as XssThroughDomAtm
from DataFlow::PathNode sink, string message
where
  // The message is the concatenation of all relevant configs
  message =
    concat(AtmConfig::AtmConfig config |
      config.isSinkCandidateWithFlow(sink)
    |
      config.getASinkEndpointType().getDescription() + ", "
      order by
        config.getASinkEndpointType().getDescription()
    )
select sink.getNode(), message
