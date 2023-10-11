---
category: minorAnalysis
---
* Added better support for API graphs when encountering `from ... import *`. For example in the code `from foo import *; Bar()`, we will now find a result for `API::moduleImport("foo").getMember("Bar").getACall()`
