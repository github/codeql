/**
 * Surfaces the endpoints that are not already known to be sinks, and are therefore used as candidates for
 * classification with an ML model.
 *
 * Note: This query does not actually classify the endpoints using the model.
 *
 * @name Automodel candidates
 * @description A query to extract automodel candidates.
 * @kind problem
 * @severity info
 * @id java/ml-powered/extract-automodel-candidates
 * @tags automodel extract candidates
 */

import AutomodelEndpointCharacteristics

from Endpoint sinkCandidate, string message
where
  not exists(CharacteristicsImpl::UninterestingToModelCharacteristic u |
    u.appliesToEndpoint(sinkCandidate)
  ) and
  // If a node is already a known sink for any of our existing ATM queries and is already modeled as a MaD sink, we
  // don't include it as a candidate. Otherwise, we might include it as a candidate for query A, but the model will
  // label it as a sink for one of the sink types of query B, for which it's already a known sink. This would result in
  // overlap between our detected sinks and the pre-existing modeling. We assume that, if a sink has already been
  // modeled in a MaD model, then it doesn't belong to any additional sink types, and we don't need to reexamine it.
  not CharacteristicsImpl::isSink(sinkCandidate, _) and
  // The message is the concatenation of all sink types for which this endpoint is known neither to be a sink nor to be
  // a non-sink, and we surface only endpoints that have at least one such sink type.
  message =
    strictconcat(AutomodelEndpointTypes::SinkType sinkType |
        not CharacteristicsImpl::isKnownSink(sinkCandidate, sinkType) and
        CharacteristicsImpl::isSinkCandidate(sinkCandidate, sinkType)
      |
        sinkType + ", "
      ) + "\n" +
      // Extract the needed metadata for this endpoint.
      any(string metadata | CharacteristicsImpl::hasMetadata(sinkCandidate, metadata))
select sinkCandidate, message
