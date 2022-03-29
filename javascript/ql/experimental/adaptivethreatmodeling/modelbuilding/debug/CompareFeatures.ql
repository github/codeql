import experimental.adaptivethreatmodeling.TaintedPathATM
import experimental.adaptivethreatmodeling.EndpointFeatures
import experimental.adaptivethreatmodeling.EndpointScoring

string getValueOrNone(EndpointFeature feature, DataFlow::Node endpoint) {
  if exists(feature.getValue(endpoint)) then feature.getValue(endpoint) = result else isNone(result)
}

predicate isNone(string value) { value = "" }

// query for comparing feature values
from
  DataFlow::Node endpoint, EndpointFeature feature1, EndpointFeature feature2, string featureValue1,
  string featureValue2
where
  feature1 instanceof ArgumentIndexFromArgumentTraversal and
  feature2 instanceof ArgumentIndex and
  featureValue1 = getValueOrNone(feature1, endpoint) and
  featureValue2 = getValueOrNone(feature2, endpoint) and
  featureValue1 != featureValue2 and
  isNone([featureValue1, featureValue2])
select endpoint, endpoint.getFile().getBaseName() as file, endpoint.getStartLine() as line,
  featureValue1, featureValue2
