import cpp

/**
 * Holds if `type` is a `Type` that typically should not be used for `sizeof` in macros or function return values.
 */
predicate isTypeDangerousForSizeof(Type type) {
  (
    type instanceof IntegralOrEnumType and
    // ignore string literals
    not type instanceof WideCharType and
    not type instanceof CharType
  )
}

/**
 * Holds if `type` is a `Type` that typically should not be used for `sizeof` in macros or function return values.
 * This predicate extends the types detected in exchange of precision.
 * For higher precision, please use `isTypeDangerousForSizeof`
 */
predicate isTypeDangerousForSizeofLowPrecision(Type type) {
  (
    // UINT8/BYTE are typedefs to char, so we treat them separately.
    // WCHAR is sometimes a typedef to UINT16, so we treat it separately too.
    type.getName() = "UINT8"
    or
    type.getName() = "BYTE"
    or
    not type.getName() = "WCHAR" and
    exists(Type ut |
      ut = type.getUnderlyingType() and
      ut instanceof IntegralOrEnumType and
      not ut instanceof WideCharType and
      not ut instanceof CharType
    )
  )
}

/**
 * Holds if the `Function` return type is dangerous as input for `sizeof`.
 */
class FunctionWithTypeDangerousForSizeofLowPrecision extends Function {
  FunctionWithTypeDangerousForSizeofLowPrecision() {
    exists(Type type | type = this.getType() | isTypeDangerousForSizeofLowPrecision(type))
  }
}
