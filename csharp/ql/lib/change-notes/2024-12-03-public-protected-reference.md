---
category: minorAnalysis
---
* Only extract *public* and *protected* members from reference assemblies. This yields an approximate average speed-up of around 10% for extraction and query execution. Custom MaD rows using `Field`-based summaries may need to be changed to `SyntheticField`-based flows if they reference private fields.
