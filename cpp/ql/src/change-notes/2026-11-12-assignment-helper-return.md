---
category: minorAnalysis
---
* The `cpp/assignment-does-not-return-this` query now recognizes assignment operators that return `*this` through non-virtual helper functions whose reachable returns directly return the same reference parameter, reducing false positives.
