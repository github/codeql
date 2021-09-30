---
category: newQuery
---
* A new query "Use of implicit Pending Intents" (`java/android/pending-intents`) has been added.
This query finds implicit and mutable PendingIntents being wrapped and sent in another implicit Intent,
which can provide access to internal components of the application or cause other unintended
effects.