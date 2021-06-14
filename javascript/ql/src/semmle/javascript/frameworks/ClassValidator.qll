/**
 * Provides predicates for reasoning about sanitization via the `class-validator` library.
 */

import javascript

/**
 * Provides predicates for reasoning about sanitization via the `class-validator` library.
 */
module ClassValidator {
  /**
   * Holds if the decorator with the given name sanitizes the input, for the purpose of taint tracking.
   */
  bindingset[name]
  private predicate isSanitizingDecoratorName(string name) {
    // Most decorators do sanitize the input, so only list those that don't.
    not name =
      [
        "IsDefined", "IsOptional", "NotEquals", "IsNotEmpty", "IsNotIn", "IsString", "IsArray",
        "Contains", "NotContains", "IsAscii", "IsByteLength", "IsDataURI", "IsFQDN", "IsJSON",
        "IsJWT", "IsObject", "IsNotEmptyObject", "IsLowercase", "IsSurrogatePair", "IsUrl",
        "IsUppercase", "Length", "MinLength", "MaxLength", "ArrayContains", "ArrayNotContains",
        "ArrayNotEmpty", "ArrayMinSize", "ArrayMaxSize", "ArrayUnique", "Allow", "ValidateNested",
        "Validate",
        // Consider "Matches" to be non-sanitizing as it is special-cased below
        "Matches"
      ]
  }

  /** Holds if the given call is a decorator that sanitizes values for the purpose of taint tracking, such as `IsBoolean()`. */
  API::CallNode sanitizingDecorator() {
    exists(string name | result = API::moduleImport("class-validator").getMember(name).getACall() |
      isSanitizingDecoratorName(name)
      or
      name = "Matches" and
      RegExp::isGenericRegExpSanitizer(RegExp::getRegExpFromNode(result.getArgument(0)), true)
    )
  }

  /** Holds if the given field has a decorator that sanitizes its value for the purpose of taint tracking. */
  predicate isFieldSanitizedByDecorator(FieldDefinition field) {
    field.getADecorator().getExpression().flow() = sanitizingDecorator().getReturn().getAUse()
  }

  pragma[noinline]
  private predicate isFieldSanitizedByDecorator(ClassDefinition cls, string name) {
    isFieldSanitizedByDecorator(cls.getField(name))
  }

  pragma[noinline]
  private ClassDefinition getClassReferencedByPropRead(DataFlow::PropRead read) {
    read.getBase().asExpr().getType().unfold().(ClassType).getClass() = result
  }

  /**
   * Holds if the given property read refers to a field that has a sanitizing decorator.
   *
   * Only holds when TypeScript types are available.
   */
  pragma[noinline]
  predicate isAccessToSanitizedField(DataFlow::PropRead read) {
    exists(ClassDefinition class_ |
      class_ = getClassReferencedByPropRead(read) and
      isFieldSanitizedByDecorator(class_, read.getPropertyName())
    )
  }
}
