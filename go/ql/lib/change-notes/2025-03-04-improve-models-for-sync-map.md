---
category: minorAnalysis
---
* We no longer track taint into a `sync.Map` via the key of a key-value pair, since there is no way of reading the keys stored in the `sync.Map` back.
