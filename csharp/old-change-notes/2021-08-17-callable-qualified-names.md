lgtm,codescanning
* Generic methods return their names (`getName()`, `getQualifiedName()` and `toStringWithTypes()`) with angle brackets,
  for example `System.Linq.Enumerable.Empty<TResult>()` returns `Empty<>`, `System.Linq.Enumerable.Empty<>` and
  `Empty<TResult>()` respectively for the unbound generic method; and `Empty<Int32>`,
  `System.Linq.Enumerable.Empty<System.Int32>` and `Empty<int>()` respectively for the constructed generic case.
* When accessing `getName()`, `getQualifiedName()` and `toStringWithTypes()` on constructed types, the type argument
  names are rendered by `getName()`, `getQualifiedName()` and `toStringWithTypes()` respectively.
* `getUndecoratedName()` can be used to access the name without angle brackets.
