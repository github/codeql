---
category: minorAnalysis
---
* `FuncTypeExpr.getNumResult()` now gets the number of result parameters. It previously got the number of result declarations, which is different when one result declaration declares more than one variable, as in `x, y int`. All uses of it expected the number of result parameters. Its QLDoc has been updated.
