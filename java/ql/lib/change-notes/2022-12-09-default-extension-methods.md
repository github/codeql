---
category: minorAnalysis
---
* The extraction of Kotlin extension methods has been improved when default parameter values are present. The dispatch and extension receiver parameters are extracted in the correct order. The `ExtensionMethod::getExtensionReceiverParameterIndex` predicate has been introduced to facilitate getting the correct extension parameter index.
