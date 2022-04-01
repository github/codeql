import javascript
import experimental.adaptivethreatmodeling.FeaturizationConfig

/**
 * A featurization config that featurizes all endpoints.
 *
 * Ideally this should not be in here, but it is needed for EnclosingFunctionName and EnclosingFunctionBody due to performance considerations :(.
 */
class NoRestrictionsFeaturizationConfig extends FeaturizationConfig {
  NoRestrictionsFeaturizationConfig() { this = "NoRestrictionsFeaturization" }

  override DataFlow::Node getAnEndpointToFeaturize() { any() }
}

class Endpoint extends DataFlow::Node {
  Endpoint() { this.asExpr().(VarAccess).getName() = "endpoint" }
}
