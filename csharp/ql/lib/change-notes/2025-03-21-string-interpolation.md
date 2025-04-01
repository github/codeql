---
category: minorAnalysis
---
* The *alignment* and *format* clauses in string interpolation expressions are now extracted. That is, in `$"Hello {name,align:format}"` *name*, *align* and *format* are extracted as children of the string interpolation *insert* `{name,align:format}`.
