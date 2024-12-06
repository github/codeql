---
category: fix
---

- Fixed a problem with the control-flow graph construction, where writing `case True:` or `case False:` would cause parts of the graph to be pruned by mistake.
