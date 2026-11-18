---
category: minorAnalysis
---
* The `cpp/assignment-does-not-return-this` query now recognizes direct calls that pass `*this` to a non-virtual helper and return its result when the helper directly returns that same reference parameter.
