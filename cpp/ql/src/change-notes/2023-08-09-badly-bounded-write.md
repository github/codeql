---
category: minorAnalysis
---
* The `cpp/badly-bounded-write` query could report false positives when a pointer was first initialized with a literal and later assigned a dynamically allocated array. These false positives now no longer occur.
