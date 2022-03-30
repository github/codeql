import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures
import TestUtil

// detailed output for the nearby tests
from Endpoint endpoint, EndpointFeature feature
select endpoint, feature.getName(), feature.getValue(endpoint)
