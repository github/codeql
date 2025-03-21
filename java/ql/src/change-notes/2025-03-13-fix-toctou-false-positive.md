---
category: minorAnalysis
---
* Fixed a false positive in "Time-of-check time-of-use race condition" (`java/toctou-race-condition`) where a field of a non-static class was not considered always-locked if it was accessed in a constructor.
