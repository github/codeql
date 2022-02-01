/**
 * EndpointScoresIntegrationTest.ql
 *
 * Extract scores for each test endpoint that is an argument to a function call in the database.
 * This is used by integration tests to verify that QL and the modeling codebase agree on the scores
 * of a set of test endpoints.
 */

import javascript
import experimental.adaptivethreatmodeling.ATMConfig
import experimental.adaptivethreatmodeling.FeaturizationConfig
import experimental.adaptivethreatmodeling.EndpointScoring::ModelScoring as ModelScoring

/**
 * A featurization config that featurizes endpoints that are arguments to function calls.
 *
 * This should only be used in extraction queries and tests.
 */
class FunctionArgumentFeaturizationConfig extends FeaturizationConfig {
  FunctionArgumentFeaturizationConfig() { this = "FunctionArgumentFeaturization" }

  override DataFlow::Node getAnEndpointToFeaturize() {
    exists(DataFlow::CallNode call | result = call.getAnArgument())
  }
}

query predicate endpointScores = ModelScoring::endpointScores/3;
