---
category: fix
---
* Fixed a bug where a Python file could be silently dropped from the analysis (with a spurious "A parse error occurred" diagnostic) when it contained a string literal, comment, or identifier with a character such as the U+FE0F emoji variation selector, a U+200D zero width joiner, or a combining accent.
