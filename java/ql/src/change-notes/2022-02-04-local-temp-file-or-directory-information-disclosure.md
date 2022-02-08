---
category: newQuery
---
* A new query titled "Temporary directory Local information disclosure" (`java/local-temp-file-or-directory-information-disclosure`) has been added.
  This query finds uses of APIs that leak potentially sensitive information to other local users via the system temporary directory.
  This query was originally [submitted as query by @JLLeitschuh](https://github.com/github/codeql/pull/4388).