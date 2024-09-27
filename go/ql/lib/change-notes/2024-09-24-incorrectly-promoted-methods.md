---
category: minorAnalysis
---
* A method in the method set of an embedded field of a struct should not be promoted to the method set of the struct if the struct has a method with the same name. This was not being enforced, which meant that there were two methods with the same qualified name, and models were sometimes being applied when they shouldn't have been. This has now been fixed.
