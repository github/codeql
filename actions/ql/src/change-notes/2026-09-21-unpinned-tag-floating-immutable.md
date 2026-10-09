---
category: minorAnalysis
---
* The `actions/unpinned-tag` query no longer treats an immutable Action as pinned when it is referenced by a floating tag such as `v4`, `v4.1`, `main` or `latest`. Only complete version tags (for example `v4.2.2`) and full commit SHAs are immutable, so floating tags are now reported for immutable Actions that are not covered by a trusted owner.
