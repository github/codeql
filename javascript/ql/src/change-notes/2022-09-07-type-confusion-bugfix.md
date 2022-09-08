---
category: fix
---

- Fixed a bug in the `js/type-confusion-through-parameter-tampering` query that would cause it to ignore
  sanitizers in branching conditions. The query should now report fewer false positives.
