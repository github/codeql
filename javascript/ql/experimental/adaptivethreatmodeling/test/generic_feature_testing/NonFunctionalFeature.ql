import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures
import TestUtil

// every feature must produce a single value for each endpoint that it computes a value for, otherwise the ML model will be confused(?)
from Endpoint endpoint, EndpointFeature feature, int arity
where arity = count(feature.getValue(endpoint)) and arity > 1
select endpoint, feature.getName(), arity
