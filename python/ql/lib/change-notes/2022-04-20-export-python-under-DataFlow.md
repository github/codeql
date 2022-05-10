---
 category: breaking
---
 * The imports made available from `import python` are no longer exposed under `DataFlow::` after doing `import semmle.python.dataflow.new.DataFlow`, for example using `DataFlow::Add` will now cause a compile error.
