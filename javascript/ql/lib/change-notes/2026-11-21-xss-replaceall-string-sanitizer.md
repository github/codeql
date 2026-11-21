---
category: minorAnalysis
---
* A `replaceAll` call whose string pattern is `<`, `'` or `"`, such as `s.replaceAll("<", "&lt;")`, is now recognized as a sanitizer by the cross-site scripting queries, such as `js/xss`, `js/reflected-xss` and `js/stored-xss`, in the same way as a global regular expression replacement.
