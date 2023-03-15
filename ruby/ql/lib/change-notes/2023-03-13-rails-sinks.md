---
 category: minorAnalysis
---
* The Active Record query methods `reorder` and `count_by_sql` are now recognised as SQL executions.
* Calls to `ActiveRecord::Connection#execute`, including those via subclasses, are now recognised as SQL executions.
* Data flow through `ActionController::Parameters#require` is now tracked properly.