---
category: minorAnalysis
---
* Fixed data-flow to captured variable references.
* We now assume that if a channel-typed field is only referred to twice in the user codebase, once in a send operation and once in a receive, then data flows from the send to the receive statement. This enables finding some cross-goroutine flow.
