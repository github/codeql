---
category: minorAnalysis
---
* The `actions/output-clobbering/high` query no longer reports simple `jq` path filters when their output remains JSON-encoded. Raw-output modes, complex filters, and unrecognized options remain reportable.
