private import csharp
import experimental.ir.implementation.IRConfiguration
import experimental.ir.internal.IntegerConstant as Ints

module AliasModels {
  class ParameterIndex = int;

  /**
   * An input to a function. This can be:
   * - The value of one of the function's parameters
   * - The value pointed to by one of function's pointer or reference parameters
   * - The value of the function's `this` pointer
   * - The value pointed to by the function's `this` pointer
   */
  abstract class FunctionInput extends string {
    FunctionInput() { none() }

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
    deprecated final predicate isInParameter(ParameterIndex index) { this.isParameter(index) }

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
    deprecated final predicate isInParameterPointer(ParameterIndex index) {
      this.isParameterDeref(index)
    }

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
    deprecated final predicate isInQualifier() { this.isQualifierObject() }

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
    predicate isReturnValueDeref() { none() }

    /**
     * Holds if `i >= 0` and `isParameterDeref(i)` holds for this value, or
     * if `i = -1` and `isQualifierObject()` holds for this value.
     */
    final predicate isParameterDerefOrQualifierObject(ParameterIndex i) {
      i >= 0 and this.isParameterDeref(i)
      or
      i = -1 and this.isQualifierObject()
    }
  }

  /**
   * An output from a function. This can be:
   * - The value pointed to by one of function's pointer or reference parameters
   * - The value pointed to by the function's `this` pointer
   * - The function's return value
   * - The value pointed to by the function's return value, if the return value is a pointer or
   *   reference
   */
  abstract class FunctionOutput extends string {
    FunctionOutput() { none() }

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
    deprecated final predicate isOutParameterPointer(ParameterIndex index) {
      this.isParameterDeref(index)
    }

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
    deprecated final predicate isOutQualifier() { this.isQualifierObject() }

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
    deprecated final predicate isOutReturnValue() { this.isReturnValue() }

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
    deprecated final predicate isOutReturnPointer() { this.isReturnValueDeref() }

    /**
     * Holds if `i >= 0` and `isParameterDeref(i)` holds for this is the value, or
     * if `i = -1` and `isQualifierObject()` holds for this value.
     */
    final predicate isParameterDerefOrQualifierObject(ParameterIndex i) {
      i >= 0 and this.isParameterDeref(i)
      or
      i = -1 and this.isQualifierObject()
    }
  }

  /**
   * Models the aliasing behavior of a library function.
   */
  abstract class AliasFunction extends Callable {
    /**
     * Holds if the address passed to the parameter at the specified index is never retained after
     * the function returns.
     *
     * Example:
     * ```csharp
     * int* g;
     * int* func(int* p, int* q, int* r, int* s, int n) {
     *   *s = 1;  // `s` does not escape.
     *   g = p;  // Stored in global. `p` escapes.
     *   if (rand()) {
     *     return q;  // `q` escapes via the return value.
     *   }
     *   else {
     *     return r + n;  // `r` escapes via the return value, even though an offset has been added.
     *   }
     * }
     * ```
     *
     * For the above function, the following terms hold:
     * - `parameterEscapesOnlyViaReturn(1)`
     * - `parameterEscapesOnlyViaReturn(2)`
     * - `parameterNeverEscapes(3)`
     */
    abstract predicate parameterNeverEscapes(int index);

    /**
     * Holds if the address passed to the parameter at the specified index escapes via the return
     * value of the function, but does not otherwise escape. See the comment for
     * `parameterNeverEscapes` for an example.
     */
    abstract predicate parameterEscapesOnlyViaReturn(int index);

    /**
     * Holds if the function always returns the value of the parameter at the specified index.
     */
    abstract predicate parameterIsAlwaysReturned(int index);

    /**
     * Holds if the address passed in via `input` is always propagated to `output`.
     */
    abstract predicate hasAddressFlow(FunctionInput input, FunctionOutput output);
  }
}
