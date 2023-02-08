---
category: newQuery
---
* Added a new query, `rb/regex/badly-anchored-regexp`, to detect regular expression validators that use `^` and `$` 
  as anchors and therefore might match only a single line of a multi-line string.
