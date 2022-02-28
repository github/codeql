---
category: minorAnalysis
---
* The `Regex` class now an abstract class that extends `StringlikeLiteral` with implementations for `RegExpLiteral` and string literals that 'flow' into functions that are known to interpret string arguments as regular expressions such `Regex.new` and `String.match`.
