---
category: newQuery
---
* Added a new query, `js/second-order-command-line-injection`, to detect shell
  commands that may execute arbitrary code when the user has control over 
  the arguments to a command-line program.
  This currently flags up unsafe invocations of git and hg.
