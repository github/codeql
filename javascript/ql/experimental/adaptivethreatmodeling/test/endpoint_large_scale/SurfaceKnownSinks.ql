/*
 * SurfaceKnownSinks.ql
 *
 * This test surfaces all the known sinks for each sink type, together with the codex prompt and the prediction codex
 * returns for each sink. It can be used to determine how well codex reproduces the manual modeling for each sink type.
 */

private import javascript as JS
import extraction.NoFeaturizationRestrictionsConfig
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.NosqlInjectionATM as NosqlInjectionAtm
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.XssATM as XssAtm
private import experimental.adaptivethreatmodeling.EndpointScoring as EndpointScoring

from
  AtmConfig::AtmConfig cfg, JS::DataFlow::PathNode sink, string prompt, string prediction,
  string groundTruth
where
  cfg.isKnownSink(sink.getNode()) and
  EndpointScoring::ModelScoring::internalEnpointScores(sink.getNode(), prediction) and
  EndpointScoring::ModelScoring::getEndpointPromptForAnyEndpoint(sink.getNode(), prompt) and
  cfg.getASinkEndpointType().getDescription() = groundTruth
select cfg, cfg.getASinkEndpointType().getEncoding(), sink.getNode(), groundTruth, prediction,
  prompt
