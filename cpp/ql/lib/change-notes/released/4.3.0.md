## 4.3.0

### New Features

* New classes `TypeofType`, `TypeofExprType`, and `TypeofTypeType` were introduced, which represent the C23 `typeof` and `typeof_unqual` operators. The `TypeofExprType` class represents the variant taking an expression as its argument. The `TypeofTypeType` class represents the variant taking a type as its argument.
* A new class `IntrinsicTransformedType` was introduced, which represents the type transforming intrinsics supported by clang, gcc, and MSVC.
* Introduced `hasDesignator()` predicates to distinguish between designated and positional initializations for both struct/union fields and array elements.
* Added the `isVla()` predicate to the `ArrayType` class. This allows queries to identify variable-length arrays (VLAs).
