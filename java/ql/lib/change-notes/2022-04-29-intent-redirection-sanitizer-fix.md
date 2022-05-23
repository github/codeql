---
category: minorAnalysis
---
Fixed a sanitizer of the query `java/android/intent-redirection`. Now, for an intent to be considered
safe against intent redirection, both its package name and class name must be checked.