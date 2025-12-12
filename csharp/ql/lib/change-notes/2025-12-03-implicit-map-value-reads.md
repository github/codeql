---
category: minorAnalysis
---
* Added implicit reads of `System.Collections.Generic.KeyValuePair.Value` at taint-tracking sinks and at inputs to additional taint steps. As a result, taint-tracking queries will now produce more results when a container is tainted.