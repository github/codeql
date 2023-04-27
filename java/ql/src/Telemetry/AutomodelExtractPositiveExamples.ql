/**
 * Surfaces endpoints are sinks with high confidence, for use as positive examples in the prompt.
 *
 * @name Positive examples (experimental)
 * @kind problem
 * @severity info
 * @id java/ml-powered/known-sink
 * @tags automodel extract examples positive
 */

private import java
private import semmle.code.java.security.ExternalAPIs as ExternalAPIs
private import AutomodelEndpointCharacteristics
private import AutomodelEndpointTypes

// private import experimental.adaptivethreatmodeling.ATMConfigs // To import the configurations of all supported Java queries
/*
 * ****** WARNING: ******
 * Before calling this query, make sure there's no codex-generated data extension file in `java/ql/lib/ext`. Otherwise,
 * the ML-generated, noisy sinks will end up polluting the positive examples used in the prompt!
 */

from Endpoint sink, SinkType sinkType, string message
where
  // Exclude endpoints that have contradictory endpoint characteristics, because we only want examples we're highly
  // certain about in the prompt.
  not erroneousEndpoints(sink, _, _, _, _, false) and
  // Extract positive examples of sinks belonging to the existing ATM query configurations.
  (
    CharacteristicsImpl::isKnownSink(sink, sinkType) and
    // If there are _any_ erroneous endpoints, return an error message for all rows. This will prevent us from
    // accidentally running this query when there's a codex-generated data extension file in `java/ql/lib/ext`.
    if not erroneousEndpoints(_, _, _, _, _, true)
    then
      message =
        sinkType + "\n" +
          // Extract the needed metadata for this endpoint.
          any(string metadata | CharacteristicsImpl::hasMetadata(sink, metadata))
    else
      message =
        "Error: There are erroneous endpoints! Please check whether there's a codex-generated data extension file in `java/ql/lib/ext`."
  )
select sink, message
