---
category: minorAnalysis
---
* The query `go/useless-assignment-to-local` ("Useless assignment to local variable") no longer reports assignments to variables captured by closures, avoiding false positives when escaped closures observe later assignments.
