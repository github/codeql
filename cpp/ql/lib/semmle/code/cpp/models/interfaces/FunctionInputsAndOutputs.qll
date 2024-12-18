/**
 * Provides a set of QL classes for indicating dataflows through a particular
 * parameter, return value, or qualifier, as well as flows at one level of
 * pointer indirection.
 */

import semmle.code.cpp.Parameter

private newtype TFunctionInput =
  TInParameter(ParameterIndex i) or
  TInParameterDeref(ParameterIndex i, int indirectionIndex) { indirectionIndex = [1, 2] } or
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
   * INTERNAL: Do not use.
   *
   * Gets the `FunctionInput` that represents the indirection of this input,
   * if any.
   */
  FunctionInput getIndirectionInput() { none() }

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
   * Holds if this is the input value pointed to (through `ind` number of indirections) by a
   * pointer parameter to a function, or the input value referred to by a reference parameter
   * to a function, where the parameter has index `index`.
   *
   * Example:
   * ```
   * void func(int n, char* p, float& r);
   * ```
   * - `isParameterDeref(1, 1)` holds for the `FunctionInput` that represents the value of `*p` (with
   *   type `char`) on entry to the function.
   * - `isParameterDeref(2, 1)` holds for the `FunctionInput` that represents the value of `r` (with type
   *   `float`) on entry to the function.
   * - There is no `FunctionInput` for which `isParameterDeref(0, _)` holds, because `n` is neither a
   *   pointer nor a reference.
   */
  predicate isParameterDeref(ParameterIndex index, int ind) {
    ind = 1 and this.isParameterDeref(index)
  }

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
  predicate isParameterDeref(ParameterIndex index) { this.isParameterDeref(index, 1) }

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
  predicate isQualifierObject(int ind) { ind = 1 and this.isQualifierObject() }

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
  predicate isQualifierObject() { this.isQualifierObject(1) }

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
   * Holds if `i >= 0` and `isParameter(i)` holds for this value, or
   * if `i = -1` and `isQualifierAddress()` holds for this value.
   */
  final predicate isParameterOrQualifierAddress(ParameterIndex i) {
    i >= 0 and this.isParameter(i)
    or
    i = -1 and this.isQualifierAddress()
  }

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
  predicate isReturnValueDeref() { this.isReturnValueDeref(1) }

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
   * - `isReturnValueDeref(1)` holds for the `FunctionInput` that represents the
   *   value of `*getPointer()` (with type `char`).
   * - `isReturnValueDeref(1)` holds for the `FunctionInput` that represents the
   *   value of `getReference()` (with type `float`).
   * - There is no `FunctionInput` of `getInt()` for which
   *   `isReturnValueDeref(_)` holds because the return type of `getInt()` is
   *   neither a pointer nor a reference.
   *
   * Note that data flows in through function return values are relatively
   * rare, but they do occur when a function returns a reference to itself,
   * part of itself, or one of its other inputs.
   */
  predicate isReturnValueDeref(int ind) { ind = 1 and this.isReturnValueDeref() }

  /**
   * Holds if `i >= 0` and `isParameterDeref(i, ind)` holds for this value, or
   * if `i = -1` and `isQualifierObject(ind)` holds for this value.
   */
  final predicate isParameterDerefOrQualifierObject(ParameterIndex i, int ind) {
    i >= 0 and this.isParameterDeref(i, ind)
    or
    i = -1 and this.isQualifierObject(ind)
  }

  /**
   * Holds if `i >= 0` and `isParameterDeref(i)` holds for this value, or
   * if `i = -1` and `isQualifierObject()` holds for this value.
   */
  final predicate isParameterDerefOrQualifierObject(ParameterIndex i) {
    this.isParameterDerefOrQualifierObject(i, 1)
  }
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

  override FunctionInput getIndirectionInput() { result = TInParameterDeref(index, 1) }
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
  int indirectionIndex;

  InParameterDeref() { this = TInParameterDeref(index, indirectionIndex) }

  override string toString() { result = "InParameterDeref " + index.toString() }

  /** Gets the zero-based index of the parameter. */
  ParameterIndex getIndex() { result = index }

  override predicate isParameterDeref(ParameterIndex i, int indirection) {
    i = index and indirectionIndex = indirection
  }

  override FunctionInput getIndirectionInput() {
    result = TInParameterDeref(index, indirectionIndex + 1)
  }
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

  override FunctionInput getIndirectionInput() { none() }
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

  override FunctionInput getIndirectionInput() { result = TInQualifierObject() }
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

  override FunctionInput getIndirectionInput() { none() }
}

private newtype TFunctionOutput =
  TOutParameterDeref(ParameterIndex i, int indirectionIndex) { indirectionIndex = [1, 2] } or
  TOutQualifierObject() or
  TOutReturnValue() or
  TOutReturnValueDeref(int indirections) { indirections = [1, 2] }

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
   * INTERNAL: Do not use.
   *
   * Gets the `FunctionOutput` that represents the indirection of this output,
   * if any.
   */
  FunctionOutput getIndirectionOutput() { none() }

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
  predicate isParameterDeref(ParameterIndex i) { this.isParameterDeref(i, 1) }

  /**
   * Holds if this is the output value pointed to by a pointer parameter (through `ind` number
   * of indirections) to a function, or the output value referred to by a reference parameter to
   * a function, where the parameter has index `index`.
   *
   * Example:
   * ```
   * void func(int n, char* p, float& r);
   * ```
   * - `isParameterDeref(1, 1)` holds for the `FunctionOutput` that represents the value of `*p` (with
   *   type `char`) on return from the function.
   * - `isParameterDeref(2, 1)` holds for the `FunctionOutput` that represents the value of `r` (with
   *   type `float`) on return from the function.
   * - There is no `FunctionOutput` for which `isParameterDeref(0, _)` holds, because `n` is neither a
   *   pointer nor a reference.
   */
  predicate isParameterDeref(ParameterIndex i, int ind) { ind = 1 and this.isParameterDeref(i) }

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
  predicate isQualifierObject() { this.isQualifierObject(1) }

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
  predicate isQualifierObject(int ind) { ind = 1 and this.isQualifierObject() }

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
  predicate isReturnValueDeref() { this.isReturnValueDeref(_) }

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
   * - `isReturnValueDeref(1)` holds for the `FunctionOutput` that represents the value of
   *   `*getPointer()` (with type `char`).
   * - `isReturnValueDeref(1)` holds for the `FunctionOutput` that represents the value of
   *   `getReference()` (with type `float`).
   * - There is no `FunctionOutput` of `getInt()` for which `isReturnValueDeref(_)` holds because the
   *   return type of `getInt()` is neither a pointer nor a reference.
   */
  predicate isReturnValueDeref(int ind) { ind = 1 and this.isReturnValueDeref() }

  /**
   * Holds if `i >= 0` and `isParameterDeref(i, ind)` holds for this is the value, or
   * if `i = -1` and `isQualifierObject(ind)` holds for this value.
   */
  final predicate isParameterDerefOrQualifierObject(ParameterIndex i, int ind) {
    i >= 0 and this.isParameterDeref(i, ind)
    or
    i = -1 and this.isQualifierObject(ind)
  }

  /**
   * Holds if `i >= 0` and `isParameterDeref(i)` holds for this is the value, or
   * if `i = -1` and `isQualifierObject()` holds for this value.
   */
  final predicate isParameterDerefOrQualifierObject(ParameterIndex i) {
    this.isParameterDerefOrQualifierObject(i, 1)
  }
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
  int indirectionIndex;

  OutParameterDeref() { this = TOutParameterDeref(index, indirectionIndex) }

  override string toString() { result = "OutParameterDeref " + index.toString() }

  ParameterIndex getIndex() { result = index }

  override predicate isParameterDeref(ParameterIndex i, int ind) {
    i = index and ind = indirectionIndex
  }

  override FunctionOutput getIndirectionOutput() {
    result = TOutParameterDeref(index, indirectionIndex + 1)
  }
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

  override FunctionOutput getIndirectionOutput() { none() }
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

  override FunctionOutput getIndirectionOutput() { result = TOutReturnValueDeref(1) }
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
  int indirectionIndex;

  OutReturnValueDeref() { this = TOutReturnValueDeref(indirectionIndex) }

  override string toString() { result = "OutReturnValueDeref" }

  override predicate isReturnValueDeref() { any() }

  override predicate isReturnValueDeref(int indirectionIndex_) {
    indirectionIndex = indirectionIndex_
  }

  override FunctionOutput getIndirectionOutput() {
    result = TOutReturnValueDeref(indirectionIndex + 1)
  }
}
