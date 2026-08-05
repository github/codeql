---
category: minorAnalysis
---
* JavaScript security queries using the `response` threat model now track promise-wrapped client response data into promise fulfillment values. This may improve results for queries such as `js/xss` when response data is consumed through `.then(...)` chains.
