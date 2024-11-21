---
category: minorAnalysis
---
* The `Guards` library (`semmle.code.cpp.controlflow.Guards`) has been improved to recognize more guard conditions. Additionally, the guards library no longer considers guards in static local initializers or global initializers as `GuardCondition`s.