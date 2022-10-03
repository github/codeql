---
category: minorAnalysis
---
* Fixed labels in the API graph pertaining to definitions of subscripts. Previously, these were labelled by `getMember` rather than `getASubscript`.
* Added `API::SubscriptReadNode` and `API::SubscriptWriteNode` with convenience predicates to obtain the index and, in the case of a write, the written value.
* Added convenience predicates to obtain a subscript at a specific index, when the index happens to be a statically known string.
