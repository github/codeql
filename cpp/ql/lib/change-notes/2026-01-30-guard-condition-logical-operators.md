---
category: fix
---
* Fixed a bug in the `GuardCondition` library which sometimes prevented binary logical operators from being recognized as guard conditions. As a result, queries using `GuardCondition` may see improved results.