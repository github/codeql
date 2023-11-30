---
category: newQuery
---
* Added a new query, `cpp/use-of-string-after-lifetime-ends`, to detect calls to `c_str` on strings that will be destroyed immediately.