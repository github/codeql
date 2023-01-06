---
category: newQuery
---
* Added a new query, `rb/regex/badly-anchored-regexp` to detect regular expression validators that use `^` and `$` 
  as anchors and thus might match a single line instead of the entire string.
