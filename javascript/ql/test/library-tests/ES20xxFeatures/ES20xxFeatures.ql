import Metrics.ES20xxFeatures

from ASTNode nd, int version, string category
where isES20xxFeature(nd, version, category)
select nd, version, category
