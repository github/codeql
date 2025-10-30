---
category: minorAnalysis
---
* The `rust/sql-injection` query now includes taint flow barriers to reduce false positives. Specifically:
  * Data parsed to numeric types (e.g., `.parse::<i32>()`) is now recognized as safe.
  * Data validated against one or more constant string values (e.g., `if x == "admin"` or `if x == "user" || x == "guest"`) is now recognized as safe within the validated branch.
  * Data validated using collection membership checks against string literals (e.g., `if ["admin", "user"].contains(&x)`) is now recognized as safe within the validated branch.
