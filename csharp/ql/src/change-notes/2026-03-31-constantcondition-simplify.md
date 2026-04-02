---
category: majorAnalysis
---
* The `cs/constant-condition` query has been simplified. The query no longer reports trivially constant conditions as they were found to generally be intentional. As a result, it should now produce fewer false positives. Additionally, the simplification means that it now reports all the results that `cs/constant-comparison` used to report, and as consequence, that query has been deleted.
