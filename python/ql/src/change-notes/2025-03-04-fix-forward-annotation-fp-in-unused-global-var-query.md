---
category: fix
---

- The `py/unused-global-variable` now no longer flags variables that are only used in forward references (e.g. the `Foo` in `def bar(x: "Foo"): ...`).
