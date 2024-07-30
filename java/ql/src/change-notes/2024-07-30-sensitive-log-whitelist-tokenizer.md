---
category: minorAnalysis
---
* Variables names containing the string "tokenizer" (case-insensitively) are no longer sources for the `java/sensitive-log` query. They normally relate to things like `java.util.StringTokenizer`, which are not sensitive information. This should fix some false positive alerts.
