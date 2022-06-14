---
category: newQuery
---
* A new query "Improper verification of intent by broadcast receiver" (`java/improper-intent-verification`) has been added. 
This query finds instances of Android `BroadcastReceiver`s that don't verify the action string of received intents when registered
to receive system intents.