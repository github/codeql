---
category: feature
---
* Added taint modeling for OData action parameter binding (`Microsoft.AspNet.OData`/`Microsoft.AspNetCore.OData`). Values cast, `as`-converted, or type-tested out of `ODataActionParameters`, and entities tracked by `Delta<T>` (via `GetInstance`, `Patch`, `Put`, `CopyChangedValues`, and `CopyUnchangedValues`), now taint the members of the target type.
