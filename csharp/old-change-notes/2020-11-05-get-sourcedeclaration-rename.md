lgtm,codescanning
* The predicate `Declaration::getSourceDeclaration/0` has been renamed to `Declaration::getUnboundDeclaration/0`.
  This is to avoid confusion, as it has nothing to do with declarations from source code (as opposed to declarations
  in assemblies), but instead has to do with generics.