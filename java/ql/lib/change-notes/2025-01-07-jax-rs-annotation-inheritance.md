---
category: minorAnalysis
---
* We now allow classes which don't have any JAX-RS annotations to inherit JAX-RS annotations from superclasses or interfaces. This is not allowed in the JAX-RS specification, but some implementations, like Apache CXF, allow it. This may lead to more alerts being found.
