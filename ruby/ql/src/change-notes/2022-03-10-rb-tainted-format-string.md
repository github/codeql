---
category: newQuery
---
* Added a new query, `rb/http-tainted-format-string`. The query finds cases where data from remote user input is used in a string formatting method in a way that allows arbitrary format specifiers to be inserted.