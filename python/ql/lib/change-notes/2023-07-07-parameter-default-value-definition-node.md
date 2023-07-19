---
category: minorAnalysis
---
* Parameters with a default value are now considered a `DefinitionNode`. This improvement was motivated by allowing type-tracking and API graphs to follow flow from such a default value to a use by a captured variable.
