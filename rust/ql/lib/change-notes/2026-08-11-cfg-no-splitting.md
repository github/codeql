---
category: minorAnalysis
---
* The control flow graph no longer uses splitting. As a consequence, the logical operations `&&`, `||`, and `!` are now modeled in pre-order, meaning that the Boolean value of such an expression is reflected in the outgoing edges of the operands instead of the operation itself.
