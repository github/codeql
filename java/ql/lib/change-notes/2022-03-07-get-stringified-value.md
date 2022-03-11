---
category: minorAnalysis
---
 * Add new predicate `CompileTimeConstantExpr.getStringifiedValue` which attempts to compute the
   `String.valueOf` string rendering of a constant expression. This predicate is now used to 
   compute the string value of an `AddExpr` that has the type `String`.
