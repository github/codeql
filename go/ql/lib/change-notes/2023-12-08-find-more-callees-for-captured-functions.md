---
category: fix
---
* When a function literal refers to a variable which has function type, there was a bug that meant that we were not able to find any possible callees for calls to that variable. This has now been fixed.
