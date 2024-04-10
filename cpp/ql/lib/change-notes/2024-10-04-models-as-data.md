---
category: feature
---
* Models-as-Data support has been added for C/C++. This feature allows flow sources, sinks and summaries to be expressed in compact strings as an alternative to modelling each source / sink / summary with explicit QL. See `dataflow/ExternalFlow.qll` for documentation and specification of the model format, and `models/implementations/ZMQ.qll` for a simple example of models. Importing models from `.yml` is not yet supported.
