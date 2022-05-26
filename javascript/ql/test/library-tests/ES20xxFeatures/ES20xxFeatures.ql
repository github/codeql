import Metrics.ES20xxFeatures

from AstNode nd, int version, string category
where isES20xxFeature(nd, version, category)
select nd, version, category
