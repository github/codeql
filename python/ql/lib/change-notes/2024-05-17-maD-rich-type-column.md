---
category: feature
---
* A Python MaD (Models as Data) row may now contain a dotted path in the `type` column. Like in Ruby, a path to a class will refer to instances of that class. This means that the summary `["foo", "Member[MyClass].Instance.Member[instance_method]", "Argument[0]", "ReturnValue", "value"]` can now be written `["foo.MS_Class", "Member[instance_method]", "Argument[0]", "ReturnValue", "value"]`. To refer to an actual class, one may add a `!` at the end of the path.