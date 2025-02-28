---
category: fix
---
* Fixed a bug that would in rare cases cause some regexp-based checks
  to seen as generic taint sanitisers, even though the underlying regexp
  is not restrictive enough. The regexps are now analysed more precisely,
  and unrestrictive regexp checks will no longer block taint flow.
