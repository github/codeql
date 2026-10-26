## 5.1.4

### Minor Analysis Improvements

* The *alignment* and *format* clauses in string interpolation expressions are now extracted. That is, in `$"Hello {name,align:format}"` *name*, *align* and *format* are extracted as children of the string interpolation *insert* `{name,align:format}`.
* Blazor support can now better recognize when a property being set is specified with a string literal, rather than referenced in a `nameof` expression.
