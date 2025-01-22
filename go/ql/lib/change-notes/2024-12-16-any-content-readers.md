---
category: minorAnalysis
---
* By implementing `ImplicitFieldReadNode` it is now possible to declare a dataflow node that reads any content (fields, array members, map keys and values). For example, this is appropriate for modelling a serialization method that flattens a potentially deep data structure into a string or byte array.
* The `Template.Execute[Template]` methods of the `text/template` package now correctly convey taint from any nested fields to their result. This may produce more results from any taint-tracking query when the `text/template` package is in use.
