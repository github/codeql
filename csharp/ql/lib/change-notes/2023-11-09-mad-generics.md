---
category: minorAnalysis
---

* The models-as-data format for types and methods with type parameters has been changed to include the names of the type parameters. For example, instead of writing
```yml
extensions:
  - addsTo:
      pack: codeql/csharp-all
      extensible: summaryModel
      data:
        - ["System.Collections.Generic", "IList<>", True, "Insert", "(System.Int32,T)", "", "Argument[1]", "Argument[this].Element", "value", "manual"]
        - ["System.Linq", "Enumerable", False, "Select<,>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Int32,TResult>)", "", "Argument[0].Element", "Argument[1].Parameter[0]", "value", "manual"]
```
one now writes
```yml
extensions:
  - addsTo:
      pack: codeql/csharp-all
      extensible: summaryModel
      data:
        - ["System.Collections.Generic", "IList<T>", True, "Insert", "(System.Int32,T)", "", "Argument[1]", "Argument[this].Element", "value", "manual"]
        - ["System.Linq", "Enumerable", False, "Select<TSource,TResult>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,System.Int32,TResult>)", "", "Argument[0].Element", "Argument[1].Parameter[0]", "value", "manual"]
```
