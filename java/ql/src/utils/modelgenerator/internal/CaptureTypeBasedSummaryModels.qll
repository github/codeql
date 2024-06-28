private import java
private import semmle.code.java.Collections
private import semmle.code.java.dataflow.internal.ContainerFlow
private import CaptureModelsSpecific as Specific
private import CaptureModelsPrinting

/**
 * A type representing instantiations of class types
 * that has a method which returns an iterator.
 */
private class IterableClass extends Class {
  private Type elementType;

  IterableClass() {
    elementType =
      unique(Type et |
        exists(Method m, RefType return, GenericType t, int position | m.getDeclaringType() = t |
          return = m.getReturnType() and
          return.getSourceDeclaration().hasQualifiedName("java.util", "Iterator") and
          t.getTypeParameter(position) = return.(ParameterizedType).getTypeArgument(0) and
          instantiates(this, t, position, et)
        )
      )
  }

  /**
   * Returns the iterator element type of `this`.
   */
  Type getElementType() { result = elementType }
}

/**
 * Holds if type `bound` is an upper bound for type `t` or equal to `t`.
 */
private predicate isEffectivelyUpperBound(Type t, Type bound) {
  t = bound or
  t.(Wildcard).getUpperBound().getType() = bound
}

/**
 * Holds if type `bound` is a lower bound for type `t` or equal to `t`.
 */
private predicate isEffectivelyLowerBound(Type t, Type bound) {
  t = bound or
  t.(Wildcard).getLowerBound().getType() = bound
}

/**
 * Holds if `t` is a container like type of `tv` (eg. `List<T>`).
 */
private predicate genericContainerType(RefType t, TypeVariable tv) {
  exists(Type et |
    et =
      [
        t.(ContainerType).getElementType(), t.(IterableClass).getElementType(),
        t.(Array).getElementType()
      ]
  |
    isEffectivelyUpperBound(et, tv)
  )
}

/**
 * Holds if `tv` is a type variable of the immediate type declaring `callable`.
 */
private predicate classTypeParameter(Callable callable, TypeVariable tv) {
  callable.getDeclaringType().(GenericType).getATypeParameter() = tv
}

/**
 * Holds if `tv` is type variable of `callable` or the type declaring `callable`.
 */
private predicate localTypeParameter(Callable callable, TypeVariable tv) {
  classTypeParameter(callable, tv) or
  callable.(GenericCallable).getATypeParameter() = tv
}

/**
 * Gets the access path postfix for `t`.
 */
private string getAccessPath(Type t) {
  if
    t instanceof Array and
    not Specific::isPrimitiveTypeUsedForBulkData(t.(Array).getElementType())
  then result = ".ArrayElement"
  else
    if t instanceof ContainerType or t instanceof IterableClass
    then result = ".Element"
    else result = ""
}

/**
 * Gets the access path for parameter `p`.
 */
private string parameterAccess(Parameter p) {
  result = "Argument[" + p.getPosition() + "]" + getAccessPath(p.getType())
}

/**
 * Holds if `callable` has a type parameter `tv` or container parameterized over type `tv`.
 */
private predicate parameter(Callable callable, string input, TypeVariable tv) {
  exists(Parameter p, Type pt |
    input = parameterAccess(p) and
    p = callable.getAParameter() and
    pt = p.getType() and
    (
      // Parameter of type tv
      isEffectivelyUpperBound(pt, tv)
      or
      // Parameter is a container of type tv
      genericContainerType(pt, tv)
    )
  )
}

/**
 * Gets the string representation of a synthetic field corresponding to `tv`.
 */
private string getSyntheticField(TypeVariable tv) {
  result = ".SyntheticField[ArgType" + tv.getIndex() + "]"
}

/**
 * Gets a models as data string representation of, how a value of type `tv`
 * can be read or stored implicitly in relation to `callable`.
 */
private string implicit(Callable callable, TypeVariable tv) {
  classTypeParameter(callable, tv) and
  not callable.isStatic() and
  exists(string access, Type decl |
    decl = callable.getDeclaringType() and
    if genericContainerType(decl, tv)
    then access = getAccessPath(decl)
    else access = getSyntheticField(tv)
  |
    result = Specific::qualifierString() + access
  )
}

private class GenericFunctionalInterface extends FunctionalInterface, GenericType {
  override string getAPrimaryQlClass() { result = "GenericFunctionalInterface" }
}

/**
 * A class of types that represents functions.
 */
private class Function extends ParameterizedType {
  private GenericFunctionalInterface fi;

  Function() { fi = this.getGenericType() }

  /**
   * Gets the typevariable that is the placeholder for the type `t`
   * used in the instantiation of `this`.
   */
  private TypeVariable getTypeReplacement(Type t) {
    exists(int position |
      instantiates(this, fi, position, t) and
      result = fi.getTypeParameter(position)
    )
  }

  /**
   * Gets the parameter type of `this` function at position `position`.
   * Note that functions are often contravariant in their parameter types.
   */
  Type getParameterType(int position) {
    exists(Type t |
      fi.getRunMethod().getParameterType(position) = this.getTypeReplacement(t) and
      isEffectivelyLowerBound(t, result)
    )
  }

  /**
   * Gets the return type of `this` function.
   * Note that functions are often covariant in their return type.
   */
  Type getReturnType() {
    exists(Type t |
      fi.getRunMethod().getReturnType() = this.getTypeReplacement(t) and
      isEffectivelyUpperBound(t, result)
    )
  }
}

/**
 * Holds if `callable` has a function parameter `f` at parameter position `position`.
 */
private predicate functional(Callable callable, Function f, int position) {
  callable.getParameterType(position) = f
}

/**
 * Gets models as data input/output access relative to the type parameter `tv` in the
 * type `t` in the scope of `callable`.
 *
 * Note: This predicate has to be inlined as `callable` is not related to `return` or `tv`
 * in every disjunction.
 */
bindingset[callable]
private string getAccess(Callable callable, Type return, TypeVariable tv) {
  return = tv and result = ""
  or
  genericContainerType(return, tv) and result = getAccessPath(return)
  or
  not genericContainerType(return, tv) and
  (
    return.(ParameterizedType).getATypeArgument() = tv
    or
    callable.getDeclaringType() = return and return.(GenericType).getATypeParameter() = tv
  ) and
  result = getSyntheticField(tv)
}

/**
 * Holds if `input` is a models as data string representation of, how a value of type `tv`
 * (or a generic parameterized over `tv`) can be generated by a function parameter of `callable`.
 */
private predicate functionalSource(Callable callable, string input, TypeVariable tv) {
  exists(Function f, int position, Type return, string access |
    functional(callable, f, position) and
    return = f.getReturnType() and
    access = getAccess(callable, return, tv) and
    input = "Argument[" + position + "].ReturnValue" + access
  )
}

/**
 * Holds if `input` is a models as data string representation of, how a
 * value of type `tv` (or a generic parameterized over `tv`)
 * can be provided as input to `callable`.
 * This includes
 * (1) The implicit synthetic field(s) of the declaring type of `callable`.
 * (2) The parameters of `callable`.
 * (3) Any function parameters of `callable`.
 */
private predicate input(Callable callable, string input, TypeVariable tv) {
  input = implicit(callable, tv)
  or
  parameter(callable, input, tv)
  or
  functionalSource(callable, input, tv)
}

/**
 * Holds if `callable` returns a value of type `tv` (or a generic parameterized over `tv`) and `output`
 * is a models as data string representation of, how data is routed to the return.
 */
private predicate returns(Callable callable, TypeVariable tv, string output) {
  exists(Type return, string access | return = callable.getReturnType() |
    access = getAccess(callable, return, tv) and
    output = "ReturnValue" + access
  )
}

/**
 * Holds if `callable` has a function parameter that accepts a value of type `tv`
 * and `output` is the models as data string representation of, how data is routed to
 * the function parameter.
 */
private predicate functionalSink(Callable callable, TypeVariable tv, string output) {
  exists(Function f, int p1, int p2 |
    functional(callable, f, p1) and
    tv = f.getParameterType(p2) and
    output = "Argument[" + p1 + "]" + ".Parameter[" + p2 + "]"
  )
}

/**
 * Holds if `output` is a models as data string representation of, how values of type `tv`
 * (or generics parameterized over `tv`) can be routed.
 * This includes
 * (1) The implicit synthetic field(s) of the declaring type of `callable`.
 * (2) The return of `callable`.
 * (3) Any function parameters of `callable`.
 */
private predicate output(Callable callable, TypeVariable tv, string output) {
  output = implicit(callable, tv)
  or
  returns(callable, tv, output)
  or
  functionalSink(callable, tv, output)
}

module ModelPrintingInput implements ModelPrintingSig {
  class Api = TypeBasedFlowTargetApi;

  string getProvenance() { result = "tb-generated" }
}

private module Printing = ModelPrinting<ModelPrintingInput>;

/**
 * A class of callables that are relevant generating summaries for based
 * on the Theorems for Free approach.
 */
class TypeBasedFlowTargetApi extends Specific::SummaryTargetApi {
  TypeBasedFlowTargetApi() { not Specific::isUninterestingForTypeBasedFlowModels(this) }

  /**
   * Gets the string representation of all type based summaries for `this`
   * inspired by the Theorems for Free approach.
   *
   * Examples could be (see Java pseudo code below)
   * (1) `get` returns a value of type `T`. We assume that the returned
   *     value was fetched from a (synthetic) field.
   * (2) `set` consumes a value of type `T`. We assume that the value is stored in
   *     a (synthetic) field.
   * (3) `apply<S>` is assumed to apply the provided function to a value stored in
   *     a (synthetic) field and return the result.
   * (4) `apply<S1,S2>` is assumed to apply the provided function to provided value
   *     and return the result.
   * ```java
   * public class MyGeneric<T> {
   *    public void set(T x) { ... }
   *    public T get() { ... }
   *    public <S> S apply<S>(Function<T, S> f) { ... }
   *    public <S1,S2> S2 apply<S1, S2>(S1 x, Function<S1, S2> f) { ... }
   * }
   * ```
   */
  string getSummaries() {
    exists(TypeVariable tv, string input, string output |
      localTypeParameter(this, tv) and
      input(this, input, tv) and
      output(this, tv, output) and
      input != output
    |
      result = Printing::asValueModel(this, input, output)
    )
  }
}

/**
 * Returns the Theorems for Free inspired typed based summaries for `api`.
 */
string captureFlow(TypeBasedFlowTargetApi api) { result = api.getSummaries() }
