---
category: minorAnalysis
---
* Added taint flow models for the `java.lang.String.(charAt|getBytes)` methods.
* Improved taint flow models for the `java.lang.String.(replace|replaceFirst|replaceAll)` methods. Additional results may be found where users do not properly sanitize their inputs.
