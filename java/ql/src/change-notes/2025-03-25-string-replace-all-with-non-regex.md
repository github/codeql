---
category: newQuery
---
* Added a new quality query, `java/string-replace-all-with-non-regex`, to detect uses of `String#replaceAll` when the first argument is not a regular expression, which should use `String#replace` instead for better performance.
