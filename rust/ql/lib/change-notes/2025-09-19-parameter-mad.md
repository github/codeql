---
category: feature
---
* The models-as-data format for sources now supports access paths of the form
  `Argument[i].Parameter[j]`. This denotes that the source passes tainted data to
  the `j`th parameter of it's `i`th argument (which must be a function or a
  closure).