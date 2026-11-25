---
category: minorAnalysis
---
* Improved `DataFlow::PostUpdateNode` generation so post-update nodes propagate along the full chain of field reads, index reads, pointer dereferences, and channel receives when a nested value may be mutated, and are no longer generated on read-only pointer dereferences.
