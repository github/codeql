lgtm,codescanning
* The extractor is now assembly-insensitive by default. This means that two entities
  with the same fully-qualified name are now mapped to the same entity in the resulting
  database, regardless of whether they belong to different assemblies. Assembly
  sensitivity can be reenabled by passing `--assemblysensitivetrap` to the extractor.
