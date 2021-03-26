/** Provides classes for modeling pointer wrapper types and expressions. */

private import cpp

/** A class that wraps a pointer type. For example, `std::unique_ptr` and `std::shared_ptr`. */
abstract class PointerWrapper extends Class {
  /** Gets a member fucntion of this class that dereferences wrapped pointer, if any. */
  abstract MemberFunction getADereferenceFunction();

  /** Gets a member fucntion of this class that returns the wrapped pointer, if any. */
  abstract MemberFunction getAnUnwrapperFunction();
}
