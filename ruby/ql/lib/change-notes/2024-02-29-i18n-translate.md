---
category: minorAnalysis
---
Calls to `I18n.translate` as well as the rails helper translate methods now propagate taint from their keyword arguments. The rails translate methods are also recognized as XSS sanitizers when using keys marked as html safe.