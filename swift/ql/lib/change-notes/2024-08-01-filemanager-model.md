---
category: minorAnalysis
---
* The model for `FileManager` no longer considers methods that return paths on the file system as taint sources. This is because these sources have been found to produce results of low value.
