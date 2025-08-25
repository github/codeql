## 2.1.3

### Minor Analysis Improvements

* The `subtypes` column has been set to true in all models-as-data models except some tests. This means that existing models will apply in some cases where they didn't before, which may lead to more alerts.

### Bug Fixes

* The behaviour of the `subtypes` column in models-as-data now matches other languages more closely.
* Fixed a bug which meant that some qualified names for promoted methods were not being recognised in some very specific circumstances.
