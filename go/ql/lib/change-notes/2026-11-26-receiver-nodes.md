---
category: breaking
---
* `DataFlow::ReceiverNode` now extends `DataFlow::ParameterNode` rather than `DataFlow::SsaParameterNode`, so receiver lookup also works for receivers that are unused or read only inside closures. Queries that need SSA-specific methods must narrow the node to `DataFlow::SsaParameterNode`.
