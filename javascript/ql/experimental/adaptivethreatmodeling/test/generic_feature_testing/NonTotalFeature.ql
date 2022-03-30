import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures
import TestUtil

// every feature should produce a value for all endpoints
from EndpointFeature feature, Endpoint endpoint
where not exists(feature.getValue(endpoint))
select endpoint, feature.getName()
