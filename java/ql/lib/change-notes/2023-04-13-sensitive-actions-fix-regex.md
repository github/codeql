---
category: minorAnalysis
---
* Fixed a bug in the regular expression used to identify sensitive information in `SensitiveActions::getCommonSensitiveInfoRegex`. This may affect the results of the queries `java/android/sensitive-communication`, `java/android/sensitive-keyboard-cache`, and `java/sensitive-log`. 
