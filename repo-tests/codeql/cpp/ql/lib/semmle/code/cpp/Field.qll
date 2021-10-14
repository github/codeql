/**
 * Provides classes representing C structure members and C++ non-static member variables.
 */

import semmle.code.cpp.Variable
import semmle.code.cpp.Enum
import semmle.code.cpp.exprs.Access

/**
 * A C structure member or C++ non-static member variable. For example the
 * member variable `m` in the following code (but not `s`):
 * ```
 * class MyClass {
 * public:
 *   int m;
 *   static int s;
 * };
 * ```
 *
 * This does not include static member variables in C++. To include static member
 * variables, use `MemberVariable` instead of `Field`.
 */
class Field extends MemberVariable {
  Field() { fieldoffsets(underlyingElement(this), _, _) }

  override string getAPrimaryQlClass() { result = "Field" }

  /**
   * Gets the offset of this field in bytes from the start of its declaring
   * type (on the machine where facts were extracted).
   */
  int getByteOffset() { fieldoffsets(underlyingElement(this), result, _) }

  /**
   * Gets the byte offset within `mostDerivedClass` of each occurence of this
   * field within `mostDerivedClass` itself or a base class subobject of
   * `mostDerivedClass`.
   * Note that for fields of virtual base classes, and non-virtual base classes
   * thereof, this predicate assumes that `mostDerivedClass` is the type of the
   * complete most-derived object.
   */
  int getAByteOffsetIn(Class mostDerivedClass) {
    result = mostDerivedClass.getABaseClassByteOffset(getDeclaringType()) + getByteOffset()
  }

  /**
   * Holds if the field can be initialized as part of an initializer list. For
   * example, in:
   * ```
   * struct S {
   *   unsigned int a : 5;
   *   unsigned int : 5;
   *   unsigned int b : 5;
   * };
   * ```
   *
   * Fields `a` and `b` are initializable, but the unnamed bitfield is not.
   */
  predicate isInitializable() {
    // All non-bitfield fields are initializable. This predicate is overridden
    // in `BitField` to handle the anonymous bitfield case.
    any()
  }

  /**
   * Gets the zero-based index of the specified field within its enclosing
   * class, counting only fields that can be initialized. This is the order in
   * which the field will be initialized, whether by an initializer list or in a
   * constructor.
   */
  pragma[nomagic]
  final int getInitializationOrder() {
    exists(Class cls, int memberIndex |
      this = cls.getCanonicalMember(memberIndex) and
      memberIndex =
        rank[result + 1](int index | cls.getCanonicalMember(index).(Field).isInitializable())
    )
  }
}

/**
 * A C structure member or C++ member variable declared with an explicit size
 * in bits. For example the member variable `x` in the following code:
 * ```
 * struct MyStruct {
 *   int x : 3;
 * };
 * ```
 */
class BitField extends Field {
  BitField() { bitfield(underlyingElement(this), _, _) }

  override string getAPrimaryQlClass() { result = "BitField" }

  /**
   * Gets the size of this bitfield in bits (on the machine where facts
   * were extracted).
   */
  int getNumBits() { bitfield(underlyingElement(this), result, _) }

  /**
   * Gets the value which appeared after the colon in the bitfield
   * declaration.
   *
   * In most cases, this will give the same value as `getNumBits`. It will
   * only differ when the value after the colon is larger than the size of
   * the variable's type. For example, given `int32_t x : 1234`,
   * `getNumBits` will give 32, whereas `getDeclaredNumBits` will give
   * 1234.
   */
  int getDeclaredNumBits() { bitfield(underlyingElement(this), _, result) }

  /**
   * Gets the offset of this bitfield in bits from the byte identified by
   * getByteOffset (on the machine where facts were extracted).
   */
  int getBitOffset() { fieldoffsets(underlyingElement(this), _, result) }

  /** Holds if this bitfield is anonymous. */
  predicate isAnonymous() { hasName("(unnamed bitfield)") }

  override predicate isInitializable() {
    // Anonymous bitfields are not initializable.
    not isAnonymous()
  }
}
