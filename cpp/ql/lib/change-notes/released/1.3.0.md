## 1.3.0

### New Features

* Models-as-data alert provenance information has been extended to the C/C++ language. Any qltests that include the edges relation in their output (for example, `.qlref`s that reference path-problem queries) will need to be have their expected output updated accordingly.
* Added subclasses of `BuiltInOperations` for `__builtin_has_attribute`, `__builtin_is_corresponding_member`, `__builtin_is_pointer_interconvertible_with_class`, `__is_assignable_no_precondition_check`, `__is_bounded_array`, `__is_convertible`, `__is_corresponding_member`, `__is_nothrow_convertible`, `__is_pointer_interconvertible_with_class`, `__is_referenceable`, `__is_same_as`, `__is_trivially_copy_assignable`, `__is_unbounded_array`, `__is_valid_winrt_type`, `_is_win_class`, `__is_win_interface`, `__reference_binds_to_temporary`, `__reference_constructs_from_temporary`, and `__reference_converts_from_temporary`.
* The class `NewArrayExpr` adds a predicate `getArraySize()` to allow a more convenient way to access the static size of the array when the extent is missing.
