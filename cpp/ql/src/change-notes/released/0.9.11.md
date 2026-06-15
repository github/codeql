## 0.9.11

### Minor Analysis Improvements

* The "Uncontrolled data used in path expression" query (`cpp/path-injection`) query produces fewer near-duplicate results.
* The "Global variable may be used before initialization" query (`cpp/global-use-before-init`) no longer raises an alert on global variables that are initialized when they are declared.
* The "Inconsistent null check of pointer" query (`cpp/inconsistent-nullness-testing`) query no longer raises an alert when the guarded check is in a macro expansion.
