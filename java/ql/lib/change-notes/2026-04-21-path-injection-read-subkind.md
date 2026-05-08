---
category: minorAnalysis
---
* Introduced a new sink kind `path-injection[read]` for Models-as-Data rows that only read from a path (such as `ClassLoader.getResource`, `FileInputStream`, `FileReader`, `Files.readAllBytes`, and related APIs). The general `java/path-injection` query continues to consider both `path-injection` and `path-injection[read]` sinks.
