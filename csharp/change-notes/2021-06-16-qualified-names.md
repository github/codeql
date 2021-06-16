lgtm,codescanning
* The following has changed in `Type::getQualifiedName`/`Type::hasQualifiedName`:
  - Type parameters now have the qualified name of the declaring generic as
    qualifier, and `<i>` as name, where `i` is the index of the type parameter.
    Example: in `class C<T> { }`, `T` has qualified name `C.<0>`.
  - Constructed types now use qualified names for type arguments. For example, the
    qualified name of `C<int>` is `C<System.Int32>`. This also includes array types
    and pointer types.
  - Nested types are now delimited by `+` instead of `.`. For example, the qualified
    name of `Inner` in `class Outer { class Inner { } }` is `Outer+Inner`.
