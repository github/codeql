---
category: fix
---

- `MatchLiteralPattern`s such as `case None: ...` are now never pruned from the extracted source code. This fixes some situations where code was wrongly identified as unreachable.
