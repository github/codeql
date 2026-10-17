---
category: minorAnalysis
---
* MongoDB collection reads modeled by the `pymongo` and `flask_pymongo` libraries are now sources under the `database` threat model. This allows queries such as `py/sql-injection` to detect second-order injection through stored documents when the `database` or `local` threat model is enabled.
