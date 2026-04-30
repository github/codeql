---
category: minorAnalysis
---
* Altered 2 patterns in the `poisonable_steps` modelling. Extra sinks are detected in the following cases: scripts executed via python modules and `go run` in directories are detected as potential mechanisms of injection. For the go execution pattern, the pattern is updated to now ignore flags that occur between go and the specific command. This change may lead to more results being detected by any queries that use that library.