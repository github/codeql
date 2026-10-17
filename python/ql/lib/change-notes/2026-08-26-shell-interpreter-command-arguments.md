---
category: minorAnalysis
---
* Direct `-c` command arguments to recognized POSIX shell interpreters through `os.exec*`,
  `os.spawn*`, `os.posix_spawn*`, and `subprocess` APIs are now treated as command-injection
  sinks.
