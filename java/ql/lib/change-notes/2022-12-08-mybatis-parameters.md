---
category: minorAnalysis
---
* We now detect SQL injection via the MyBatis library when the `@Param` annotation is not used, but the unannotated parameter is referred to by name regardless. This is an undocumented feature of the MyBatis library; the documentation suggests either `@Param` should be used, or a parameter should be referred to by position, e.g. `{arg0}`.
