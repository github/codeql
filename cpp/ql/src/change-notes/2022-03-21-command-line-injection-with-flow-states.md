---
category: minorAnalysis
---
* The `cpp/command-line-injection` query now takes into account calling contexts across string concatenations. This removes false positives due mismatched calling contexts before and after string concatenations.
