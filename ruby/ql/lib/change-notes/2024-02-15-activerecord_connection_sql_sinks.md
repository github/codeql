---
category: minorAnalysis
---
* Calls to several methods of `ActiveRecord::Connection`, such as `ActiveRecord::Connection#exec_query`, are now recognized as SQL executions, including those via subclasses.