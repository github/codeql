---
category: minorAnalysis
---
* The `java/zipslip` query now excludes read-only file operations from its sinks. Previously, it reused the full `path-injection` sink set, which includes read-only operations such as `ClassLoader.getResource()`, `FileInputStream`, and `File.exists()`. Since Zip Slip specifically targets file extraction (write) vulnerabilities, these read-only sinks are no longer considered, reducing false positives.
