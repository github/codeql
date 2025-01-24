---
category: majorAnalysis
---
* The `js/incorrect-suffix-check` query now recognises some good patterns of the form `origin.indexOf("." + allowedOrigin)` that were previously falsely flagged.