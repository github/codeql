/*
 * For internal use only.
 */

private import experimental.adaptivethreatmodeling.FeaturizationConfig

/**
 * A featurization config that featurizes all endpoints.
 *
 * This should only be used in extraction queries and tests.
 */
class NoRestrictionsFeaturizationConfig extends FeaturizationConfig {
  NoRestrictionsFeaturizationConfig() { this = "NoRestrictionsFeaturization" }

  override DataFlow::Node getAnEndpointToFeaturize() { any() }
}
