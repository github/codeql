---
category: minorAnalysis
---
* We no longer track taint into a `sync.Map` via the key of a key-value pair, since we do not model any way in which keys can be read from a `sync.Map`.
