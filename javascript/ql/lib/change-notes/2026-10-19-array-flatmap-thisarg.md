---
category: minorAnalysis
---
* Fixed the flow summary for `Array.prototype.flatMap`. The `thisArg` argument now flows to the callback's `this` instead of its index parameter.
