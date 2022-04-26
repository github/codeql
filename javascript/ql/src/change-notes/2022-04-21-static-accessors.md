---
category: minorAnalysis
---
* The call graph now deals more precisely with calls to accessors (getters and setters).
  Previously, calls to static accessors were not resolved, and some method calls were
  incorrectly seen as calls to an accessor. Both issues have been fixed.
