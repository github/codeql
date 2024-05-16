---
category: breaking
---
* Removed `local` query variants. The results pertaining to local sources can be found using the non-local counterpart query. As an example, the results previously found by `java/unvalidated-url-redirection-local` can be found by `java/unvalidated-url-redirection`, if the `local` threat model is enabled. The removed queries are `java/path-injection-local`, `java/command-line-injection-local`, `java/xss-local`, `java/sql-injection-local`, `java/http-response-splitting-local`, `java/improper-validation-of-array-construction-local`, `java/improper-validation-of-array-index-local`, `java/tainted-format-string-local`, `java/tainted-arithmetic-local`, `java/unvalidated-url-redirection-local`, `java/xxe-local` and `java/tainted-numeric-cast-local`.
