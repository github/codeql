import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures
import TestUtil

// every endpoint should have at least one feature value, otherwise the test source is likely malformed
from Endpoint endpoint
where not exists(EndpointFeature f | exists(f.getValue(endpoint)))
select endpoint
