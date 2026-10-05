/**
 * Provides data-flow modelling of constructor patterns / enum-case constructors.
 */

private import unified
private import AllDataFlow
private import codeql.unified.internal.ExprPositions
private import codeql.unified.internal.NameBinding as NameBinding
private import codeql.unified.internal.typeinference.TypeInference as T

/**
 * A constructor pattern, such as `Optional.some(let x)`.
 */
class ConstructorPattern extends CallExpr {
  ConstructorPattern() { isInBindingContext(this, _) }
}

/**
 * Gets the unqualified name of the enum-case contructor that might be referenced by `call`.
 */
private string getShortConstructorName(CallExpr call) {
  result = call.getCallee().(MemberAccessExpr).getMemberName()
  // note: enum constructors can only be accessed qualified (possibly with leading-dot syntax)
  // so do not do this for Identifiers
}

/**
 * Holds if a constructor pattern has the given short `name` and `arity`.
 */
pragma[nomagic]
private predicate isSignatureUsedInConstructorPattern(string name, int arity) {
  exists(ConstructorPattern ctor |
    name = getShortConstructorName(ctor) and
    arity = ctor.getNumberOfArguments()
  )
}

/** Holds if `callable` is an enum-case constructor */
private predicate isEnumCaseConstructor(ConstructorDeclaration callable) {
  callable = any(ClassLikeDeclaration cls | cls.hasModifier("enum_case")).getAMember()
}

/**
 * Holds if `call` resolves to a known enum-case constructor, or is assumed to resolve to an unseen enum-case constructor.
 */
pragma[nomagic]
private predicate assumeResolvesToEnumCaseConstructor(CallExpr call) {
  call instanceof ConstructorPattern
  or
  isEnumCaseConstructor(T::resolveCallTarget(call))
  or
  // If the `E` in `E.foo(...)` could not be resolved, check if the name `foo` matches a constructor pattern.
  exists(MemberAccessExpr callee, Expr base |
    callee = call.getCallee() and
    base = callee.getBase() and
    not exists(NameBinding::getStaticBindingTargetFromRef(base)) and
    not exists(T::inferType(base)) and
    isSignatureUsedInConstructorPattern(callee.getMemberName(), call.getNumberOfArguments())
  )
}

/**
 * Gets the field name for the enum-case data parameter corresponding to the given argument.
 */
string getEnumCaseParameterFieldFromArgument(CallExpr call, Argument arg) {
  assumeResolvesToEnumCaseConstructor(call) and
  exists(int i |
    // Note: The label name is optional when calling an enum-case constructor, but the arguments
    // must occur in declaration order, so use the raw argument index to handle both the labelled and unlabelled cases.
    arg = call.getArgument(i) and
    result = getShortConstructorName(call) + "." + i
  )
}
