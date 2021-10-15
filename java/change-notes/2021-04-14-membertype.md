lgtm,codescanning
* A CodeQL class `MemberType` is introduced to describe nested classes. Its `getQualifiedName` method returns `$`-delimited nested type names (for example, `mypackage.Outer$Middle$Inner`), where previously the same type would be named differently depending on whether it was addressed as a `NestedType` or a `Member`.
