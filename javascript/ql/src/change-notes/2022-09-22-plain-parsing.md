---
category: minorAnalysis
---
* Improved how the JavaScript parser handles ambiguities between plain JavaScript and dialects such as Flow and E4X that use the same file extension. The parser now prefers plain JavaScript if possible, falling back to dialects only if the source code can not be parsed as plain JavaScript. Previously, there were rare cases where parsing would fail because the parser would erroneously attempt to parse dialect-specific syntax in a regular JavaScript file.