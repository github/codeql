---
category: minorAnalysis
---
* The `analysis/AlertSuppression.ql` query has moved to the root folder. Users that refer to this query by path should update their configurations. The query has been updated to support the new `# codeql[query-id]` supression comments. These comments can be used to suppress an alert and must be placed on a blank line before the alert. In addition the legacy `# lgtm` and `# lgtm[query-id]` comments can now also be place on the line before an alert.
