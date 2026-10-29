## 4.2.0

### New Features

* Calling conventions explicitly specified on function declarations (`__cdecl`, `__stdcall`, `__fastcall`, etc.)  are now represented as specifiers of those declarations.
* A new class `CallingConventionSpecifier` extending the `Specifier` class was introduced, which represents explicitly specified calling conventions.
