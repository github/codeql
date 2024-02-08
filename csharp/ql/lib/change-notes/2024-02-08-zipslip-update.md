---
category: minorAnalysis
---
* The `cs/zipslip` query now correctly handles sanitizer wrappers.
* The `cs/zipslip` query now correctly handles `String.StartsWith` method calls with a qualifier /that did not directly/ come from a call to `Path.Combine` as not a sanitizer.