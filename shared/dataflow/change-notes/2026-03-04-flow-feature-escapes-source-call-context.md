---
category: feature
---
* Two new flow features `FeatureEscapesSourceCallContext` and `FeatureEscapesSourceCallContextOrEqualSourceSinkCallContext` have been added. The former implies that the sink must be reached from the source by escaping the source call context, that is, flow must either return from the callable containing the source or use a jump-step before reaching the sink. The latter is the disjunction of the former and the existing `FeatureEqualSourceSinkCallContext` flow feature.