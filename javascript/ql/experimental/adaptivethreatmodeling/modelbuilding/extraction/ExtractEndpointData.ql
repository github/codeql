/*
 * For internal use only.
 *
 * Extracts training and evaluation data we can use to train ML models for ML-powered queries.
 */

import ExtractEndpointData as ExtractEndpointData

query predicate endpoints = ExtractEndpointData::endpoints/5;

query predicate tokenFeatures = ExtractEndpointData::tokenFeatures/3;
