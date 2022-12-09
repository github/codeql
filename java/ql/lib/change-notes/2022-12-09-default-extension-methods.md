---
category: minorAnalysis
---
* The extraction of extension methods have been improved when default parameter values are present. The dispatch and extension receiver parameters are extracted in the correct order. The `ExtensionMethod::getExtensionParameterIndex` predicate has been introduced to facilitate getting the correct extension parameter index.
