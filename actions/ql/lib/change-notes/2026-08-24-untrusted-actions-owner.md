---
category: minorAnalysis
---
* The `trustedActionsOwnerDataModel` extensible predicate, used by the `actions/unpinned-tag` query, now supports removing an owner from the trusted set by adding an entry prefixed with `!` (for example, `!github`). This makes it possible to distrust first-party owners (`actions`, `github`, `advanced-security`) so that unpinned tags for their Actions are reported.
