---
category: deprecated
---
* All references to the `DefinitionExt` and `PhiReadNode` classes in the SSA library have been deprecated. The concept of phi-read nodes is now strictly an internal implementation detail. Their sole use-case is to improve the structure of the use-use flow relation for data flow, and this use-case remains supported by the `DataFlowIntegration` module.
