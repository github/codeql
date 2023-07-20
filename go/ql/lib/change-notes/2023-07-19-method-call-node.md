---
category: fix
---
* The definition of `DataFlow::MethodCallNode` has been expanded to include `DataFlow::CallNode`s where what is being called is a variable that has a method assigned to it within the calling function. This means we can now follow data flow into the receiver of such a method call.
