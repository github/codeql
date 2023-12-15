---
category: minorAnalysis
---
* `CallNode::getACallee` and related predicates now recognise more callees accessed via a function variable, in particular when the callee is stored into a global variable or is captured by an anonymous function. This may lead to new alerts where data-flow into such a callee is relevant.
