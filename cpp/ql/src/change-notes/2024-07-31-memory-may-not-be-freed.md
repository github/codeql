---
category: minorAnalysis
---
* Fixed false positives in the `cpp/memory-may-not-be-freed` ("Memory may not be freed") query involving class methods that returned an allocated field of that class being misidentified as allocators.
