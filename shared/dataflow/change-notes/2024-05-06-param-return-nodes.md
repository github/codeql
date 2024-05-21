---
category: minorAnalysis
---
* The data flow library now adds intermediate nodes when data flows out of a function via a parameter, in order to make path explanations easier to follow. The intermediate nodes have the same location as the underlying parameter, but must be accessed via `PathNode.asParameterReturnNode` instead of `PathNode.asNode`.