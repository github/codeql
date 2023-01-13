/*
 * For internal use only.
 *
 * Extracts training data we can use to train ML models for ML-powered queries.
 */

private import ExtractEndpointDataTraining as ExtractEndpointDataTraining

query predicate endpoints = ExtractEndpointDataTraining::reformattedTrainingEndpoints/5;

query predicate tokenFeatures = ExtractEndpointDataTraining::tokenFeatures/3;
