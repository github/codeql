import go
private import semmle.go.dataflow.Properties

/**
 * Holds if `validationKind` is a validation kind that restricts to alphanumeric characters,
 * which we consider safe for use in a URL.
 */
private predicate isAlphanumericValidationKind(string validationKind) {
  validationKind in [
      "alpha", "alphanum", "alphaunicode", "alphanumunicode", "number", "numeric", "uuid"
    ]
}

private string getKeyAndValuesRegex() { result = "([a-zA-Z0-9]+):\"([a-zA-Z0-9,]+)\"" }

/**
 * A struct field with json tags like `key:"value1,value2"`.
 */
class FieldWithTags extends FieldDecl {
  FieldWithTags() { this.getTag().toString().regexpMatch("`([a-zA-Z0-9]+:\"[a-zA-Z0-9,]+\" *)+`") }

  /**
   * Holds if this field's tag maps `key` to `value`.
   * For example: the tag `json:"word" binding:"required,alpha"` yields `key: "json", value: "word"`
   * and `key: "binding" values: "required","alpha"`.
   */
  predicate getTagByKeyValue(string key, string value) {
    exists(string tag, string key_value, string values |
      this.getTag().toString() = tag and
      // Each key_value is like key:"value1,value2"
      tag.regexpFind(getKeyAndValuesRegex(), _, _) = key_value and
      // key is the "key" from key:"value1,value2"
      key_value.regexpCapture(getKeyAndValuesRegex(), 1) = key and
      // values are the value1,value2 (without the quotation marks) from key:"value1,value2"
      key_value.regexpCapture(getKeyAndValuesRegex(), 2) = values and
      // value is value1 or value2 from key:"value1,value2"
      values.regexpFind("[a-zA-Z0-9]+", _, _) = value
    )
  }
}

/**
 * A node that reads from a field with a tag indicating it
 * must be alphanumeric (for example, having the tag `binding:"alpha"`).
 */
class AlphanumericStructFieldRead extends DataFlow::Node {
  string key;

  AlphanumericStructFieldRead() {
    exists(FieldWithTags decl, Field field, string tag |
      this = field.getARead() and
      field.getDeclaration() = decl.getNameExpr(0) and
      decl.getTagByKeyValue(key, tag) and
      isAlphanumericValidationKind(tag)
    )
  }

  string getKey() { result = key }
}

/**
 * A node that is considered safe because it (a) reads a field with a tag indicating it should be
 * alphanumeric, and (b) is guarded by a call to a validation function checking that it really
 * is alphanumeric.
 *
 * See `AlphanumericStructFieldRead` and `isAlphanumericValidationKind` for supported tags.
 * See `StructValidationFunction` for supported binding functions.
 */
class CheckedAlphanumericStructFieldRead extends AlphanumericStructFieldRead {
  CheckedAlphanumericStructFieldRead() {
    exists(StructValidationFunction guard, SelectorExpr selector |
      guard.getAGuardedNode().asExpr() = selector.getBase() and
      selector = this.asExpr() and
      this.getKey() = guard.getValidationKindKey()
    )
  }
}

/**
 * A function that validates a struct, checking that fields conform to restrictions given as a tag.
 *
 * The Gin `Context.Bind` family of functions apply checks according to a `binding:` tag, and the
 * Go-Playground Validator checks fields that have a `validate:` tag.
 */
private class StructValidationFunction extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  Expr checked;
  boolean safeOutcome;
  string validationKindKey;

  StructValidationFunction() {
    exists(Function bindFunction, DataFlow::CallNode bindCall, DataFlow::Node resultErr |
      (
        // Gin call
        bindFunction
            .(Method)
            .hasQualifiedName("github.com/gin-gonic/gin", "Context",
              [
                "BindJSON", "MustBindWith", "BindWith", "Bind", "ShouldBind", "ShouldBindBodyWith",
                "ShouldBindJSON", "ShouldBindWith"
              ]) and
        validationKindKey = "binding"
        or
        // Validator Struct
        bindFunction
            .(Method)
            .hasQualifiedName("github.com/go-playground/validator", "Validate", "Struct") and
        validationKindKey = "validate"
      ) and
      bindCall = bindFunction.getACall() and
      checked = dereference(bindCall.getAnArgument()) and
      resultErr = bindCall.getResult().getASuccessor*() and
      nilProperty().checkOn(this, safeOutcome, resultErr)
    )
  }

  override predicate checks(Expr e, boolean branch) { e = checked and branch = safeOutcome }

  /**
   * Returns the struct tag key from which this validation function draws its validation kind.
   *
   * For example, if this returns `xyz` then this function looks for a struct tag like
   * `` mustBeNumeric string `xyz:"numeric"` ``
   */
  string getValidationKindKey() { result = validationKindKey }
}

/**
 * If `nd` is an address-of expression `&a`, returns expressions `&a` and `a`. Otherwise, returns `nd` as-is.
 */
private Expr dereference(DataFlow::Node nd) {
  nd.asExpr().(AddressExpr).getOperand() = result
  or
  nd.asExpr() = result
}

/**
 * A validation performed by package `validator`'s method `Var` to check that an expression is
 * alphanumeric (see `isAlphanumericValidationKind` for more information) sanitizes guarded uses
 * of the same variable.
 */
class ValidatorVarCheck extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  DataFlow::CallNode callToValidator;
  boolean outcome;

  ValidatorVarCheck() {
    exists(Method validatorMethod, DataFlow::Node resultErr |
      validatorMethod.hasQualifiedName("github.com/go-playground/validator", "Validate", "Var") and
      callToValidator = validatorMethod.getACall() and
      isAlphanumericValidationKind(callToValidator.getArgument(1).getStringValue()) and
      resultErr = callToValidator.getResult().getASuccessor*() and
      nilProperty().checkOn(this, outcome, resultErr)
    )
  }

  override predicate checks(Expr e, boolean branch) {
    callToValidator.getArgument(0).asExpr() = e and
    branch = outcome
  }
}
