---
category: minorAnalysis
---
* Classes and methods that are seen with several different paths during the extraction process (for example, packaged into different JAR files) now report an arbitrarily selected location via their `getLocation` and `hasLocationInfo` predicates, rather than reporting all of them. This may lead to reduced alert duplication.
