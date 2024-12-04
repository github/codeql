---
category: majorAnalysis
---
* The `js/incomplete-sanitization` query now also checks regular expressions constructed using `new RegExp(..)`. Previously it only checked regular expression literals.
* Regular expression-based sanitisers implemented with `new RegExp(..)` are now detected in more cases.
* Regular expression related queries now account for unknown flags.
