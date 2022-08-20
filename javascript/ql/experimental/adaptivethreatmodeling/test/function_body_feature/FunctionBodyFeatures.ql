import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures as EndpointFeatures
import experimental.adaptivethreatmodeling.FunctionBodyFeatures as FunctionBodyFeatures
import extraction.NoFeaturizationRestrictionsConfig

query predicate functionBodyFeatures(string functionName, string feature) {
  exists(Function function, DataFlow::Node endpoint |
    function = FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint) and
    functionName = function.getName() and
    EndpointFeatures::tokenFeatures(endpoint, "enclosingFunctionBody", feature)
  )
}
