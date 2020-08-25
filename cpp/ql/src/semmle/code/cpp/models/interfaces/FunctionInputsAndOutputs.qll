/**
 * Provides a set of QL classes for indicating dataflows through a particular
 * parameter, return value, or qualifier, as well as flows at one level of
 * pointer indirection.
 */

import semmle.code.cpp.Parameter

private newtype TFunctionInput =
  TInParameter(ParameterIndex i) or
  TInParameterDeref(ParameterIndex i) or
  TInQualifierObject() or
  TInQualifierAddress() or
  TInReturnValueDeref()

/**
 * An input to a function. This can be:
 * - The value of one of the function's parameters
 * - The value pointed to by one of function's pointer or reference parameters
 * - The value of the function's `this` pointer
 * - The value pointed to by the function's `this` pointer
 */
class FunctionInput extends TFunctionInput {
  abstract string toString();

  /**
   * Holds if this is the input value of the parameter with index `index`.
   *
   * Example:
   * ```
   * void func(int n, char* p, float& r);
   * ```
   * - `isParameter(0)` holds for the `FunctionInput` that represents the value of `n` (with type
   *   `int`) on entry to the function.
   * - `isParameter(1)` holds for the `FunctionInput` that represents the value of `p` (with type
   *   `char*`) on entry to the function.
   * - `isParameter(2)` holds for the `FunctionInput` that represents the "value" of the reference
   *   `r` (with type `float&`) on entry to the function, _not_ the value of the referred-to
   *   `float`.
   */
  predicate isParameter(ParameterIndex index) { none() }

  /**
   * Holds if this is the input value of the parameter with index `index`.
   * DEPRECATED: Use `isParameter(index)` instead.
   */
  deprecated final predicate isInParameter(ParameterIndex index) { isParameter(index) }

  /**
   * Holds if this is the input value pointed to by a pointer parameter to a function, or the input
   * value referred to by a reference parameter to a function, where the parameter has index
   * `index`.
   *
   * Example:
   * ```
   * void func(int n, char* p, float& r);
   * ```
   * - `isParameterDeref(1)` holds for the `FunctionInput` that represents the value of `*p` (with
   *   type `char`) on entry to the function.
   * - `isParameterDeref(2)` holds for the `FunctionInput` that represents the value of `r` (with type
   *   `float`) on entry to the function.
   * - There is no `FunctionInput` for which `isParameterDeref(0)` holds, because `n` is neither a
   *   pointer nor a reference.
   */
  predicate isParameterDeref(ParameterIndex index) { none() }

  /**
   * Holds if this is the input value pointed to by a pointer parameter to a function, or the input
   * value referred to by a reference parameter to a function, where the parameter has index
   * `index`.
   * DEPRECATED: Use `isParameterDeref(index)` instead.
   */
  deprecated final predicate isInParameterPointer(ParameterIndex index) { isParameterDeref(index) }

  /**
   * Holds if this is the input value pointed to by the `this` pointer of an instance member
   * function.
   *
   * Example:
   * ```
   * struct C {
   *   void mfunc(int n, char* p, float& r) const;
   * };
   * ```
   * - `isQualifierObject()` holds for the `FunctionInput` that represents the value of `*this`
   *   (with type `C const`) on entry to the function.
   */
  predicate isQualifierObject() { none() }

  /**
   * Holds if this is the input value pointed to by the `this` pointer of an instance member
   * function.
   * DEPRECATED: Use `isQualifierObject()` instead.
   */
  deprecated final predicate isInQualifier() { isQualifierObject() }

  /**
   * Holds if this is the input value of the `this` pointer of an instance member function.
   *
   * Example:
   * ```
   * struct C {
   *   void mfunc(int n, char* p, float& r) const;
   * };
   * ```
   * - `isQualifierAddress()` holds for the `FunctionInput` that represents the value of `this`
   *   (with type `C const *`) on entry to the function.
   */
  predicate isQualifierAddress() { none() }

  /**
   * Holds if this is the input value pointed to by the return value of a
   * function, if the function returns a pointer, or the input value referred
   * to by the return value of a function, if the function returns a reference.
   *
   * Example:
   * ```
   * char* getPointer();
   * float& getReference();
   * int getInt();
   * ```
   * - `isReturnValueDeref()` holds for the `FunctionInput` that represents the
   *   value of `*getPointer()` (with type `char`).
   * - `isReturnValueDeref()` holds for the `FunctionInput` that represents the
   *   value of `getReference()` (with type `float`).
   * - There is no `FunctionInput` of `getInt()` for which
   *   `isReturnValueDeref()` holds because the return type of `getInt()` is
   *   neither a pointer nor a reference.
   *
   * Note that data flows in through function return values are relatively
   * rare, but they do occur when a function returns a reference to itself,
   * part of itself, or one of its other inputs.
   */
  predicate isReturnValueDeref() { none() }
}

/**
 * The input value of a parameter.
 *
 *  Example:
 * ```
 * void func(int n, char* p, float& r);
 * ```
 * - There is an `InParameter` representing the value of `n` (with type `int`) on entry to the
 *   function.
 * - There is an `InParameter` representing the value of `p` (with type `char*`) on entry to the
 *   function.
 * - There is an `InParameter` representing the "value" of the reference `r` (with type `float&`) on
 *    entry to the function, _not_ the value of the referred-to `float`.
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
 *
 * Example:
 * ```
 * void func(int n, char* p, float& r);
 * ```
 * - There is an `InParameterDeref` with `getIndex() = 1` that represents the value of `*p` (with
 *   type `char`) on entry to the function.
 * - There is an `InParameterDeref` with `getIndex() = 2` that represents the value of `r` (with
 *   type `float`) on entry to the function.
 * - There is no `InParameterDeref` representing the value of `n`, because `n` is neither a pointer
 *   nor a reference.
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
 *
 * Example:
 * ```
 * struct C {
 *   void mfunc(int n, char* p, float& r) const;
 * };
 * ```
 * - `InQualifierObject` represents the value of `*this` (with type `C const`) on entry to the
 *   function.
 */
class InQualifierObject extends FunctionInput, TInQualifierObject {
  override string toString() { result = "InQualifierObject" }

  override predicate isQualifierObject() { any() }
}

/**
 * The input value of the `this` pointer of an instance member function.
 *
 * Example:
 * ```
 * struct C {
 *   void mfunc(int n, char* p, float& r) const;
 * };
 * ```
 * - `InQualifierAddress` represents the value of `this` (with type `C const *`) on entry to the
 *   function.
 */
class InQualifierAddress extends FunctionInput, TInQualifierAddress {
  override string toString() { result = "InQualifierAddress" }

  override predicate isQualifierAddress() { any() }
}

/**
 * The input value pointed to by the return value of a function, if the
 * function returns a pointer, or the input value referred to by the return
 * value of a function, if the function returns a reference.
 *
 * Example:
 * ```
 * char* getPointer();
 * float& getReference();
 * int getInt();
 * ```
 * - `InReturnValueDeref` represents the value of `*getPointer()` (with type
 *   `char`).
 * - `InReturnValueDeref` represents the value of `getReference()` (with type
 *   `float`).
 * - `InReturnValueDeref` does not represent the return value of `getInt()`
 *   because the return type of `getInt()` is neither a pointer nor a reference.
 *
 * Note that data flows in through function return values are relatively
 * rare, but they do occur when a function returns a reference to itself,
 * part of itself, or one of its other inputs.
 */
class InReturnValueDeref extends FunctionInput, TInReturnValueDeref {
  override string toString() { result = "InReturnValueDeref" }

  override predicate isReturnValueDeref() { any() }
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

  /**
   * Holds if this is the output value pointed to by a pointer parameter to a function, or the
   * output value referred to by a reference parameter to a function, where the parameter has
   * index `index`.
   *
   * Example:
   * ```
   * void func(int n, char* p, float& r);
   * ```
   * - `isParameterDeref(1)` holds for the `FunctionOutput` that represents the value of `*p` (with
   *   type `char`) on return from the function.
   * - `isParameterDeref(2)` holds for the `FunctionOutput` that represents the value of `r` (with
   *   type `float`) on return from the function.
   * - There is no `FunctionOutput` for which `isParameterDeref(0)` holds, because `n` is neither a
   *   pointer nor a reference.
   */
  predicate isParameterDeref(ParameterIndex i) { none() }

  /**
   * Holds if this is the output value pointed to by a pointer parameter to a function, or the
   * output value referred to by a reference parameter to a function, where the parameter has
   * index `index`.
   * DEPRECATED: Use `isParameterDeref(index)` instead.
   */
  deprecated final predicate isOutParameterPointer(ParameterIndex index) { isParameterDeref(index) }

  /**
   * Holds if this is the output value pointed to by the `this` pointer of an instance member
   *   function.
   *
   * Example:
   * ```
   * struct C {
   *   void mfunc(int n, char* p, float& r);
   * };
   * ```
   * - `isQualifierObject()` holds for the `FunctionOutput` that represents the value of `*this`
   *   (with type `C`) on return from the function.
   */
  predicate isQualifierObject() { none() }

  /**
   * Holds if this is the output value pointed to by the `this` pointer of an instance member
   * function.
   * DEPRECATED: Use `isQualifierObject()` instead.
   */
  deprecated final predicate isOutQualifier() { isQualifierObject() }

  /**
   * Holds if this is the value returned by a function.
   *
   * Example:
   * ```
   * int getInt();
   * char* getPointer();
   * float& getReference();
   * ```
   * - `isReturnValue()` holds for the `FunctionOutput` that represents the value returned by
   *   `getInt()` (with type `int`).
   * - `isReturnValue()` holds for the `FunctionOutput` that represents the value returned by
   *   `getPointer()` (with type `char*`).
   * - `isReturnValue()` holds for the `FunctionOutput` that represents the "value" of the reference
   *   returned by `getReference()` (with type `float&`), _not_ the value of the referred-to
   *   `float`.
   */
  predicate isReturnValue() { none() }

  /**
   * Holds if this is the value returned by a function.
   * DEPRECATED: Use `isReturnValue()` instead.
   */
  deprecated final predicate isOutReturnValue() { isReturnValue() }

  /**
   * Holds if this is the output value pointed to by the return value of a function, if the function
   * returns a pointer, or the output value referred to by the return value of a function, if the
   * function returns a reference.
   *
   * Example:
   * ```
   * char* getPointer();
   * float& getReference();
   * int getInt();
   * ```
   * - `isReturnValueDeref()` holds for the `FunctionOutput` that represents the value of
   *   `*getPointer()` (with type `char`).
   * - `isReturnValueDeref()` holds for the `FunctionOutput` that represents the value of
   *   `getReference()` (with type `float`).
   * - There is no `FunctionOutput` of `getInt()` for which `isReturnValueDeref()` holds because the
   *   return type of `getInt()` is neither a pointer nor a reference.
   */
  predicate isReturnValueDeref() { none() }

  /**
   * Holds if this is the output value pointed to by the return value of a function, if the function
   * returns a pointer, or the output value referred to by the return value of a function, if the
   * function returns a reference.
   * DEPRECATED: Use `isReturnValueDeref()` instead.
   */
  deprecated final predicate isOutReturnPointer() { isReturnValueDeref() }
}

/**
 * The output value pointed to by a pointer parameter to a function, or the output value referred to
 * by a reference parameter to a function.
 *
 * Example:
 * ```
 * void func(int n, char* p, float& r);
 * ```
 * - There is an `OutParameterDeref` with `getIndex()=1` that represents the value of `*p` (with
 *   type `char`) on return from the function.
 * - There is an `OutParameterDeref` with `getIndex()=2` that represents the value of `r` (with
 *   type `float`) on return from the function.
 * - There is no `OutParameterDeref` representing the value of `n`, because `n` is neither a
 *   pointer nor a reference.
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
 *
 * Example:
 * ```
 * struct C {
 *   void mfunc(int n, char* p, float& r);
 * };
 * ```
 * - The `OutQualifierObject` represents the value of `*this` (with type `C`) on return from the
 *   function.
 */
class OutQualifierObject extends FunctionOutput, TOutQualifierObject {
  override string toString() { result = "OutQualifierObject" }

  override predicate isQualifierObject() { any() }
}

/**
 * The value returned by a function.
 *
 * Example:
 * ```
 * int getInt();
 * char* getPointer();
 * float& getReference();
 * ```
 * - `OutReturnValue` represents the value returned by
 *   `getInt()` (with type `int`).
 * - `OutReturnValue` represents the value returned by
 *   `getPointer()` (with type `char*`).
 * - `OutReturnValue` represents the "value" of the reference returned by `getReference()` (with
 *   type `float&`), _not_ the value of the referred-to `float`.
 */
class OutReturnValue extends FunctionOutput, TOutReturnValue {
  override string toString() { result = "OutReturnValue" }

  override predicate isReturnValue() { any() }
}

/**
 * The output value pointed to by the return value of a function, if the function returns a pointer,
 * or the output value referred to by the return value of a function, if the function returns a
 * reference.
 *
 * Example:
 * ```
 * char* getPointer();
 * float& getReference();
 * int getInt();
 * ```
 * - `OutReturnValueDeref` represents the value of `*getPointer()` (with type `char`).
 * - `OutReturnValueDeref` represents the value of `getReference()` (with type `float`).
 * - `OutReturnValueDeref` does not represent the return value of `getInt()` because the return type
 *   of `getInt()` is neither a pointer nor a reference.
 */
class OutReturnValueDeref extends FunctionOutput, TOutReturnValueDeref {
  override string toString() { result = "OutReturnValueDeref" }

  override predicate isReturnValueDeref() { any() }
}
