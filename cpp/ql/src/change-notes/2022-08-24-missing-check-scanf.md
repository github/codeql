---
category: newQuery
---
* Added a new medium-precision query, `cpp/missing-check-scanf`, which detects `scanf` output variables that are used without a proper return-value check to see that they were actually written. A variation of this query was originally contributed as an [experimental query by @ihsinme](https://github.com/github/codeql/pull/8246).
