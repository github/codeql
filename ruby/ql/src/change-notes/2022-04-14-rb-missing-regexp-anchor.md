---
category: newQuery
---
* Added a new query, `rb/regex/missing-regexp-anchor`, which finds regular expressions which are improperly anchored. Validations using such expressions are at risk of being bypassed.