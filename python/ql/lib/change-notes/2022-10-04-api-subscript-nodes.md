---
category: minorAnalysis
---
* Fixed labels in the API graph pertaining to definitions of subscripts. Previously, these were labelled by `getMember` rather than `getASubscript`.
* Added edges for indices of subscripts to the API graph. Now a subscripted API node will have an edge to the API node for the index expression. So if `foo` is matched by API node `A`, then `"key"` in `foo["key"]` will be matched by the API node `A.getIndex()`, which can be used to track the origin of the index.
* Added `API::SubscriptReadNode` and `API::SubscriptWriteNode` with convenience predicates to obtain the index and, in the case of a write, the written value. This is useful to tie indices to matching subscript expressions.
* Added convenience predicates `getSubscript("key")` to obtain a subscript at a specific index, when the index happens to be a statically known string.
