---
category: fix
---

- We would previously confuse all captured variables into a single scope entry node. Now they each get their own node so they can be tracked properly.
