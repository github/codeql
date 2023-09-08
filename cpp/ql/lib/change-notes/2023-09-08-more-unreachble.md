---
category: minorAnalysis
---
* Functions that do not return due to calling functions that don't return (e.g. `exit`) are now detected as
 non returning in the IR and dataflow.