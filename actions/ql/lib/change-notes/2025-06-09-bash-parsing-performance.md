---
category: minorAnalysis
---
* Fixed performance issues in the parsing of Bash scripts in workflow files,
  which led to out-of-disk errors when analysing certain workflow files with
  complex interpolations of shell commands or quoted strings.