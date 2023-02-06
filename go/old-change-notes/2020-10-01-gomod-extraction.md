lgtm,codescanning
* The extractor now only extracts go.mod files belonging to extracted packages. In particular, vendored go.mod files will no longer be extracted unless the vendored package is explicitly passed to the extractor. This will remove unexpected `GoModExpr` and similar expressions seen by queries.
