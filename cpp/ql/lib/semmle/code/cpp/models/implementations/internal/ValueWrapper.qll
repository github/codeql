/** Internal helpers for contained-value assignment and emplacement models. */

private import cpp

/** Holds if `t` is an arithmetic or enumeration type. */
predicate isNumeric(Type t) { t instanceof ArithmeticType or t instanceof Enum }

/** Holds if both types are pointers in an instantiated, well-typed operation. */
predicate isPointerConversion(Type source, Type target) {
  source instanceof PointerType and target instanceof PointerType
}

/**
 * Holds if the types agree or a conversion between scalar types needs no user code.
 * Callers modeling emplacement must additionally exclude class-typed construction.
 */
predicate noUserDefinedConversion(Type source, Type target) {
  source = target
  or
  isNumeric(source) and isNumeric(target)
  or
  isPointerConversion(source, target)
}

/** Gets a supported indirection suffix for the contents of a value wrapper. */
string getContentStars() { result = ["", "*", "**", "***", "****"] }

/**
 * Gets whether a conversion preserves values at the given indirection.
 * A derived-to-base pointer conversion may adjust the address, so only its
 * pointee contents are value-preserving. Numeric conversions propagate taint.
 */
bindingset[stars]
boolean preservesConvertedValue(Type source, Type target, string stars) {
  if
    source = target
    or
    isPointerConversion(source, target) and stars != ""
  then result = true
  else result = false
}
