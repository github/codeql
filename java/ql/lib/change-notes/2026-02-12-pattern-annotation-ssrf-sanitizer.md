---
category: minorAnalysis
---
* More ways of checking that a string matches a regular expression are now considered as sanitizers for various queries, including `java/ssrf` and `java/path-injection`. In particular, being annotated with `@javax.validation.constraints.Pattern` is now recognised as a sanitizer for those queries.
