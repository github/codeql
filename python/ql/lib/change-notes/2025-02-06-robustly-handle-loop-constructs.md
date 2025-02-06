---
category: fix
---

- Using the `break` and `continue` keywords outside of a loop, which is a syntax error but is accepted by our parser, would cause the control-flow construction to fail. This is now no longer the case.
