/**
 * Provides a set of QL classes for indicating dataflows through a particular
 * parameter, return value, or qualifier, as well as flows at one level of
 * pointer indirection.
 */

import semmle.code.cpp.Parameter

/**
 * An `int` that is a parameter index for some function.  This is needed for binding in certain cases.
 */
class ParameterIndex extends int {
  ParameterIndex() { exists(Parameter p | this = p.getIndex()) }
}

private newtype TFunctionInput =
  TInParameter(ParameterIndex i) or
  TInParameterDeref(ParameterIndex i) or
  TInQualifierObject() or
  TInQualifierAddress()

/**
 * An input to a function. This can be:
 * - The value of one of the function's parameters
 * - The value pointed to by one of function's pointer or reference parameters
 * - The value of the function's `this` pointer
 * - The value pointed to by the function's `this` pointer
 */
class FunctionInput extends TFunctionInput {
  abstract string toString();

  predicate isParameter(ParameterIndex index) { none() }

  predicate isParameterDeref(ParameterIndex index) { none() }

  predicate isQualifierObject() { none() }

  predicate isQualifierAddress() { none() }
}

/**
 * The input value of a parameter to a function.
 * Example:
 * ```cpp
 * void func(int n, char* p, float& r);
 * ```
 * The `InParameter` with `getIndex() = 0` represents the value of `n` (with type `int`) on entry to
 * the function.
 * The `InParameter` with `getIndex() = 1` represents the value of `p` (with type `char*`) on entry
 * to the function.
 * The `InParameter` with `getIndex() = 2` represents the "value" of the reference `r` (with type 
 * `float&`) on entry to the function, _not_ the value of the referred-to `float`.
 */
class InParameter extends FunctionInput, TInParameter {
  ParameterIndex index;

  InParameter() { this = TInParameter(index) }

  override string toString() { result = "InParameter " + index.toString() }

  /** Gets the zero-based index of the parameter. */
  ParameterIndex getIndex() { result = index }

  override predicate isParameter(ParameterIndex i) { i = index }
}

/**
 * The input value pointed to by a pointer parameter to a function, or the input value referred to
 * by a reference parameter to a function.
 * Example:
 * ```cpp
 * void func(int n, char* p, float& r);
 * ```
 * The `InParameterDeref` with `getIndex() = 1` represents the value of `*p` (with type `char`) on
 * entry to the function.
 * The `InParameterDeref` with `getIndex() = 2` represents the value of `r` (with type `float`) on
 * entry to the function.
 * There is no `InParameterDeref` with `getIndex() = 0`, because `n` is neither a pointer nor a
 * reference.
 */
class InParameterDeref extends FunctionInput, TInParameterDeref {
  ParameterIndex index;

  InParameterDeref() { this = TInParameterDeref(index) }

  override string toString() { result = "InParameterDeref " + index.toString() }

  /** Gets the zero-based index of the parameter. */
  ParameterIndex getIndex() { result = index }

  override predicate isParameterDeref(ParameterIndex i) { i = index }
}

/**
 * The input value pointed to by the `this` pointer of an instance member function.
 * Example:
 * ```cpp
 * struct C {
 *   void mfunc(int n, char* p, float& r) const;
 * };
 * ```
 * The `InQualifierObject` represents the value of `*this` (with type `C const`) on entry to the
 * function.
 */
class InQualifierObject extends FunctionInput, TInQualifierObject {
  override string toString() { result = "InQualifierObject" }

  override predicate isQualifierObject() { any() }
}

/**
 * The input value of the `this` pointer of an instance member function.
 * Example:
 * ```cpp
 * struct C {
 *   void mfunc(int n, char* p, float& r) const;
 * };
 * ```
 * The `InQualifierAddress` represents the value of `this` (with type `C const *`) on entry to the
 * function.
 */
class InQualifierAddress extends FunctionInput, TInQualifierAddress {
  override string toString() { result = "InQualifierAddress" }

  override predicate isQualifierAddress() { any() }
}

private newtype TFunctionOutput =
  TOutParameterDeref(ParameterIndex i) or
  TOutQualifierObject() or
  TOutReturnValue() or
  TOutReturnValueDeref()

/**
 * An output from a function. This can be:
 * - The value pointed to by one of function's pointer or reference parameters
 * - The value pointed to by the function's `this` pointer
 * - The function's return value
 * - The value pointed to by the function's return value, if the return value is a pointer or
 *   reference
 */
class FunctionOutput extends TFunctionOutput {
  abstract string toString();

  predicate isParameterDeref(ParameterIndex i) { none() }

  predicate isQualifierObject() { none() }

  predicate isReturnValue() { none() }

  predicate isReturnValueDeref() { none() }
}

/**
 * The output value pointed to by a pointer parameter to a function, or the output value referred to
 * by a reference parameter to a function.
 * Example:
 * ```cpp
 * void func(int n, char* p, float& r);
 * ```
 * The `OutParameterDeref` with `getIndex() = 1` represents the value of `*p` (with type `char`) on
 * return from the function.
 * The `OutParameterDeref` with `getIndex() = 2` represents the value of `r` (with type `float`) on
 * return from the function.
 * There is no `OutParameterDeref` with `getIndex() = 0`, because `n` is neither a pointer nor a
 * reference.
 */
class OutParameterDeref extends FunctionOutput, TOutParameterDeref {
  ParameterIndex index;

  OutParameterDeref() { this = TOutParameterDeref(index) }

  override string toString() { result = "OutParameterDeref " + index.toString() }

  ParameterIndex getIndex() { result = index }

  override predicate isParameterDeref(ParameterIndex i) { i = index }
}

/**
 * The output value pointed to by the `this` pointer of an instance member function.
 * Example:
 * ```cpp
 * struct C {
 *   void mfunc(int n, char* p, float& r);
 * };
 * ```
 * The `OutQualifierObject` represents the value of `*this` (with type `C`) on return from the
 * function.
 */
class OutQualifierObject extends FunctionOutput, TOutQualifierObject {
  override string toString() { result = "OutQualifier" }

  override predicate isQualifierObject() { any() }
}

/**
 * The value returned by a function.
 * Example:
 * ```cpp
 * int getInt();
 * char* getPointer();
 * float& getReference();
 * ```
 * The `OutReturnValue` for `getInt()` represents the value returned by `getInt()` (with type
 * `int`).
 * The `OutReturnValue` for `getPointer()` represents the value returned by `getPointer()` (with
 * type `char*`).
 * The `OutReturnValue` for `getReference()` represents the "value" of the reference returned by
 * `getReference()` (with type `float&`), _not_ the value of the referred-to `float`.
 */
class OutReturnValue extends FunctionOutput, TOutReturnValue {
  override string toString() { result = "OutReturnValue" }

  override predicate isReturnValue() { any() }
}

/**
 * The output value pointed to by the return value of a function, if the function returns a pointer,
 * or the output value referred to by the return value of a function, if the function returns a
 * reference.
 * Example:
 * ```cpp
 * char* getPointer();
 * float& getReference();
 * int getInt();
 * ```
 * The `OutReturnValueDeref` for `getPointer()` represents the value of `*getPointer()` (with type
 * `char`).
 * The `OutReturnValueDeref` for `getReference()` represents the value of `getReference()` (with
 * type `float`).
 * There is no `OutReturnValueDeref` for `getInt()`, because the return type of `getInt()` is
 * neither a pointer nor a reference.
 */
class OutReturnValueDeref extends FunctionOutput, TOutReturnValueDeref {
  override string toString() { result = "OutReturnValueDeref" }

  override predicate isReturnValueDeref() { any() }
}
