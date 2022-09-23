---
category: minorAnalysis
---
* Changed `CallNode.getArgByName` such that it has results for keyword arguments given after a dictionary unpacking argument, as the `bar=2` argument in `func(foo=1, **kwargs, bar=2)`.
