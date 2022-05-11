lgtm,codescanning
* The data-flow library now recognises more side-effects of method chaining (e.g. `someObject.setX(clean).setY(tainted).setZ...` having a side-effect on `someObject`), as well as other related circumstances where a function input is directly passed to its output. All queries that use data-flow analysis, including most security queries, may return more results accordingly.
