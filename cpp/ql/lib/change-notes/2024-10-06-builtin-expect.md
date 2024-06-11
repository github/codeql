---
category: minorAnalysis
---
* The "Guards" library (`semmle.code.cpp.controlflow.Guards`) now also infers guards from calls to the builtin operation `__builtin_expect`. As a result, some queries may produce fewer false positives.