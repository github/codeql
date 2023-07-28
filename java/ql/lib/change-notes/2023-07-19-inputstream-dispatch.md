---
category: minorAnalysis
---
* Improved the precision of virtual dispatch of `java.io.InputStream` methods. Now, calls to these methods will not dispatch to arbitrary implementations of `InputStream` if there is a high-confidence alternative (like a models-as-data summary).
  