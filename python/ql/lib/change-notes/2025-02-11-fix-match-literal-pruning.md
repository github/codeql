---
category: fix
---

- `MatchLiteralPattern`s are now never pruned, as this could lead to code being wrongly identified as unreachable.
