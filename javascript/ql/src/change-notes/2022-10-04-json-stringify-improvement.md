---
category: minorAnalysis
---
* Improved taint tracking behavior when the `JSON.stringify` method called. Previously, `JsonStringifyTaintStep` detects only if the source is equal to an argument. Now, it can detect the case that the argument is object and source is located in its property.
