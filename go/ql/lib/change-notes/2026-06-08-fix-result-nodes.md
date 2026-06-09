---
category: minorAnalysis
---
* `DataFlow::ResultNode`s are no longer created for returned expressions in functions with named result parameters. In this case there are already result nodes corresponding to `IR::ReadResultInstruction`s at the end of the function body.
