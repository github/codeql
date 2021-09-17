import go
import semmle.go.dataflow.Properties

/**
 * Only these tags are safe to build an URL
 */
private predicate isValidTag(string tag) {
  tag in ["alpha", "alphanum", "alphaunicode", "alphanumunicode", "number", "numeric"]
}

/**
 * Struct's field with json tags like `key:"value1,value2"`
 */
class FieldWithTags extends FieldDecl {
  FieldWithTags() { this.getTag().toString().regexpMatch("`([a-zA-Z0-9]+:\"[a-zA-Z0-9,]+\" *)+`") }

  /**
   * It retrieves the values of a key
   * For example: `json:"word" binding:"required,alpha"` key: "json" value:"word"
   * key: "binding" values: "required","alpha".
   */
  predicate getTagByKeyValue(string key, string value) {
    exists(string tag, string key_value, string values |
      this.getTag().toString() = tag and
      // Each key_value is like key:"value1,value2"
      tag.regexpFind("[a-zA-Z0-9]+:\"[a-zA-Z0-9,]+\"", _, _) = key_value and
      // key is the "key" from key:"value1,value2"
      key_value.regexpCapture("([a-zA-Z0-9]+):\"([a-zA-Z0-9,]+)\"", 1) = key and
      // values are the value1,value2 (without the quotation marks) from key:"value1,value2"
      key_value.regexpCapture("([a-zA-Z0-9]+):\"([a-zA-Z0-9,]+)\"", 2) = values and
      // value is value1 or value2 from key:"value1,value2"
      values.regexpFind("[a-zA-Z0-9]+", _, _) = value
    )
  }
}

/**
 * If the tainted variable comes from a valid tagged field (for example: binding:"alpha")
 * it is safe
 */
class TaggedNode extends DataFlow::Node {
  string key;

  TaggedNode() {
    exists(FieldWithTags decl, Field field, string tag |
      this = field.getARead() and
      field.getDeclaration() = decl.getNameExpr(0) and
      decl.getTagByKeyValue(key, tag) and
      isValidTag(tag)
    )
  }

  string getKey() { result = key }
}

/**
 * When we receive a body from a request, we can use certain tags on our struct's fields to hint
 * the binding function to run some validations for that field. If this binding functions returns
 * no error, then we consider these fields safe for SSRF.
 *
 * See TaggedNode and isValidTag for supported tags. See BindErrorCheck for supported binding
 * functions.
 */
class BodyTagSanitizer extends TaggedNode {
  BodyTagSanitizer() {
    exists(BindErrorCheck guard, SelectorExpr selector |
      guard.getAGuardedNode().asExpr() = selector.getBase() and
      selector = this.asExpr() and
      this.getKey() = guard.getSafeKey()
    )
  }
}

/**
 * An error check for a bind function considered as a barrier guard
 */
private class BindErrorCheck extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  Expr checked;
  boolean outcome;
  string safeKey;

  BindErrorCheck() {
    exists(
      Function bindFunction, DataFlow::CallNode bindCall, DataFlow::Node resultErr, Property prop
    |
      (
        // Gin call
        bindFunction
            .(Method)
            .hasQualifiedName("github.com/gin-gonic/gin", "Context",
              ["BindJSON", "MustBindWith", "BindWith", "Bind", "ShouldBind", "ShouldBindBodyWith",
                  "ShouldBindJSON", "ShouldBindWith"]) and
        safeKey = "binding"
        or
        //Validator Struct
        bindFunction
            .(Method)
            .hasQualifiedName("github.com/go-playground/validator", "Validate", "Struct") and
        safeKey = "validate"
      ) and
      bindCall = bindFunction.getACall() and
      checked = dereference(bindCall.getAnArgument()) and
      resultErr = bindCall.getResult().getASuccessor*() and
      prop.checkOn(this, outcome, resultErr) and
      prop.isNil()
    )
  }

  override predicate checks(Expr e, boolean branch) { e = checked and branch = outcome }

  string getSafeKey() { result = safeKey }
}

/**
 * If nd is of type &a, returns nodes for &a and a. Else, return nd as is.
 */
private Expr dereference(DataFlow::Node nd) {
  nd.asExpr().(AddressExpr).getOperand() = result
  or
  nd.asExpr() = result
}

/**
 * A validation performed by package validator's method Var is a sanitizer guard
 * only when using valid tags (see isValidTag for more information)
 */
class ValidatorVarCheck extends DataFlow::BarrierGuard, DataFlow::EqualityTestNode {
  DataFlow::CallNode callToValidator;
  boolean outcome;

  ValidatorVarCheck() {
    exists(Method validatorMethod, Property prop, DataFlow::Node resultErr |
      validatorMethod.hasQualifiedName("github.com/go-playground/validator", "Validate", "Var") and
      callToValidator = validatorMethod.getACall() and
      isValidTag(callToValidator.getArgument(1).getStringValue()) and
      resultErr = callToValidator.getResult().getASuccessor*() and
      prop.checkOn(this, outcome, resultErr) and
      prop.isNil()
    )
  }

  override predicate checks(Expr e, boolean branch) {
    callToValidator.getArgument(0).asExpr() = e and
    branch = outcome
  }
}
