---
category: minorAnalysis
---

* The predicate `UnboundGeneric::getName` now prints the number of type parameters as a `` `N`` suffix, instead of a `<,...,>` suffix. For example, the unbound generic type
`System.Collections.Generic.IList<T>` is printed as ``IList`1`` instead of `IList<>`.
* The predicates `hasQualifiedName`, `getQualifiedName`, and `getQualifiedNameWithTypes` have been deprecated, and are instead replaced by `hasFullyQualifiedName`, `getFullyQualifiedName`, and `getFullyQualifiedNameWithTypes`, respectively. The new predicates use the same format for unbound generic types as mentioned above.
* These changes also affect models-as-data rows that refer to a field or a property belonging to a generic type. For example, instead of writing
```yml
extensions:
  - addsTo:
      pack: codeql/csharp-all
      extensible: summaryModel
      data:
        - ["System.Collections.Generic", "Dictionary<TKey,TValue>", False, "Add", "(System.Collections.Generic.KeyValuePair<TKey,TValue>)", "", "Argument[0].Property[System.Collections.Generic.KeyValuePair<,>.Key]", "Argument[this].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key]", "value", "manual"]
```
one now writes
```yml
extensions:
  - addsTo:
      pack: codeql/csharp-all
      extensible: summaryModel
      data:
        - ["System.Collections.Generic", "Dictionary<TKey,TValue>", False, "Add", "(System.Collections.Generic.KeyValuePair<TKey,TValue>)", "", "Argument[0].Property[System.Collections.Generic.KeyValuePair`2.Key]", "Argument[this].Element.Property[System.Collections.Generic.KeyValuePair`2.Key]", "value", "manual"]
```
