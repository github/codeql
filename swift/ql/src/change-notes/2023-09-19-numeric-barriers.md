---
category: minorAnalysis
---
* Adder barriers for numeric type values to the injection-like queries, to reduce false positive results where the user input that can be injected is constrainted to a numerical value. The queries updated by this change are: "Predicate built from user-controlled sources" (`swift/predicate-injection`), "Database query built from user-controlled sources" (`swift/sql-injection`), "Uncontrolled format string" (`swift/uncontrolled-format-string`), "JavaScript Injection" (`swift/unsafe-js-eval`) and "Regular expression injection" (`swift/regex-injection`).
