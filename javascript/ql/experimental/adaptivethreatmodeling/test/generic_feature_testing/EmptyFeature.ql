import javascript
import experimental.adaptivethreatmodeling.EndpointFeatures
import experimental.adaptivethreatmodeling.FeaturizationConfig
import TestUtil

// every feature must produce a value for at least one endpoint, otherwise the feature is completely broken, or a relevant test example is missing
from EndpointFeature feature
where forall(Endpoint endpoint | not exists(feature.getValue(endpoint)))
select feature.getName()
