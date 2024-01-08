---
category: minorAnalysis
---
* Parsing of division operators (`/`) at the end of a line has been improved. Before they were wrongly interpreted as the start of a regular expression literal (`/.../`) leading to syntax errors.
* Parsing of `case` statements that are formatted with the value expression on a different line than the `case` keyword  has been improved and should no longer lead to syntax errors.
