---
category: fix
---
* `ImportStaticTypeMember` and `ImportStaticOnDemand` are now properly considering inherited members (except for inherited member types).
* `ImportStaticOnDemand` predicates do not have non-`static` members and initializer methods as results anymore.
* `ImportOnDemandFromPackage.getAnImport()` does not have nested types as result anymore.
