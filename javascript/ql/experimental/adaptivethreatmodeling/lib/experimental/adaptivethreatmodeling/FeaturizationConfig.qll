import javascript

/**
 * A configuration that defines which endpoints should be featurized.
 *
 * This is used as a performance optimization to ensure that we only featurize the endpoints we need
 * to featurize.
 */
abstract class FeaturizationConfig extends string {
  bindingset[this]
  FeaturizationConfig() { any() }

  abstract DataFlow::Node getAnEndpointToFeaturize();
}
