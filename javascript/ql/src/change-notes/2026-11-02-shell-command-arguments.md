---
category: minorAnalysis
---
* The `js/command-line-injection` query now reports remote input that reaches argument arrays when the `shell` option is enabled. The `js/shell-command-constructed-from-input` query also recognizes string-valued shell paths. Both queries now handle `execFile` calls without a callback.
