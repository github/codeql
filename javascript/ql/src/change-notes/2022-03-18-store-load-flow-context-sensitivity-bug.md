---
category: minorAnalysis
---
* Fixed an issue that would sometimes prevent the data-flow analysis from finding flow
  paths through a function that stores its result on an object.
  This may lead to more results for the security queries.
