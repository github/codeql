lgtm,codescanning
* The following has changed in `Type::getQualifiedName`/`Type::hasQualifiedName`:
  - Type parameters now have the qualified name which is simply the name of the type
    parameter itself. Example: in `class C<T> { }`, `T` has qualified name `T`.
  - Constructed types now use qualified names for type arguments. For example, the
    qualified name of `C<int>` is `C<System.Int32>`. This also includes array types
    and pointer types.
  - Nested types are now delimited by `+` instead of `.`. For example, the qualified
    name of `Inner` in `class Outer { class Inner { } }` is `Outer+Inner`.
