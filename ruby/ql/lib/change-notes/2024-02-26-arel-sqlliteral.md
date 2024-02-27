---
category: minorAnalysis
---
Calls to `Arel::Nodes::SqlLiteral.new` are now modeled as instances of the `SqlConstruction` concept, as well as propagating taint from their argument.