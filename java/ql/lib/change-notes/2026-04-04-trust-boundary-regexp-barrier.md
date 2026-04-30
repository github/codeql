---
category: minorAnalysis
---
* The `java/trust-boundary-violation` query now recognizes regular expression checks (including `String.matches()` guards and `@javax.validation.constraints.Pattern` annotations) as sanitizers, consistent with the existing treatment of ESAPI validators. This reduces false positives when input is validated against a pattern before being stored in a session.
