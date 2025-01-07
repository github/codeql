---
category: minorAnalysis
---
* The data flow library has been updated to track types in a slightly different way: The type of the tainted data (which may be stored into fields, etc.) is tracked more precisely, while the types of intermediate containers for nested contents is tracked less precisely. This may have a slight effect on false positives for complex flow paths.
