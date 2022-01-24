---
category: newQuery
---
* A new query "Use of implicit PendingIntents" (`java/android/pending-intents`) has been added.
This query finds implicit and mutable `PendingIntents` sent to an unspecified third party
component, which may provide an attacker with access to internal components of the application
or cause other unintended effects.