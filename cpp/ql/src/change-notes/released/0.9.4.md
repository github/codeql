## 0.9.4

### Minor Analysis Improvements

* Corrected 2 false positive with `cpp/incorrect-string-type-conversion`: conversion of byte arrays to wchar and new array allocations converted to wchar.
* The "Incorrect return-value check for a 'scanf'-like function" query (`cpp/incorrectly-checked-scanf`) no longer reports an alert when an explicit check for EOF is added.
* The "Incorrect return-value check for a 'scanf'-like function" query (`cpp/incorrectly-checked-scanf`) now recognizes more EOF checks.
* The "Potentially uninitialized local variable" query (`cpp/uninitialized-local`) no longer reports an alert when the local variable is used as a qualifier to a static member function call.
* The diagnostic query `cpp/diagnostics/successfully-extracted-files` now considers any C/C++ file seen during extraction, even one with some errors, to be extracted / scanned. This affects the Code Scanning UI measure of scanned C/C++ files.
