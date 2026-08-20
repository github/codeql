---
category: fix
---
* The query `cs/useless-cast-to-self` no longer reports casts when both the expression type and the cast target type are unknown, which can occur in `build-mode: none` databases.
