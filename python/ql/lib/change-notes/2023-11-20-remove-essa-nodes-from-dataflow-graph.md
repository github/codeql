---
category: fix
---

- The dataflow graph no longer contains SSA variables. Instead, flow is directed via the corresponding controlflow nodes. This should make the graph and the flow simpler to understand. Minor improvements in flow computation has been observed, but in general negligible changes to alerts are expected.
