/**
 * Surfaces endpoints are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (experimental)
 * @kind problem
 * @id java/ml-powered/known-sink
 * @tags experimental security
 */

private import java
import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.ExternalAPIs as ExternalAPIs
private import experimental.adaptivethreatmodeling.EndpointCharacteristics as EndpointCharacteristics
private import experimental.adaptivethreatmodeling.EndpointTypes
private import experimental.adaptivethreatmodeling.ATMConfig as AtmConfig
private import experimental.adaptivethreatmodeling.SqlInjectionATM as SqlInjectionAtm
private import experimental.adaptivethreatmodeling.TaintedPathATM as TaintedPathAtm
private import experimental.adaptivethreatmodeling.RequestForgeryATM as RequestForgeryAtm

/*
 * ****** WARNING: ******
 * Before calling this query, make sure there's no codex-generated data extension file in `java/ql/lib/ext`. Otherwise,
 * the ML-gnerarated, noisy sinks will end up poluting the positive examples used in the prompt!
 */

from DataFlow::Node sink, AtmConfig::AtmConfig config, EndpointType sinkType, string message
where
  // If there are _any_ erroneous endpoints, return nothing. This will prevent us from accidentally running this query
  // when there's a codex-generated data extension file in `java/ql/lib/ext`.
  not EndpointCharacteristics::erroneousEndpoints(_, _, _, _, _) and
  // Extract positive examples of sinks belonging to the existing ATM query configurations.
  (
    config.isKnownSink(sink, sinkType) and
    // It's valid for a node to satisfy the logic for both `isSink` and `isSanitizer`, but in that case it will be
    // treated by the actual query as a sanitizer, since the final logic is something like
    // `isSink(n) and not isSanitizer(n)`. We don't want to include such nodes as positive examples in the prompt.
    not config.isSanitizer(sink) and
    // Include only sinks that are arguments to an external API call, because these are the sinks we are most interested
    // in.
    sink instanceof ExternalAPIs::ExternalApiDataNode and
    message =
      sinkType + "\n" +
        // Extract the needed metadata for this endpoint.
        any(string metadata | EndpointCharacteristics::hasMetadata(sink, metadata))
  )
select sink, message
