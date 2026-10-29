---
category: majorAnalysis
---
* Library models now use the dynamic models-as-data format (`sourceModel`, `sinkModel`, `summaryModel`, and `typeModel` rows identified by a `(type, path)` pair), which does not require type information. This replaces the models previously imported from the Swift analysis. Type models describing how to obtain instances of library types can be generated from `.swiftinterface` files using `unified/scripts/generate-type-models.sh`.
