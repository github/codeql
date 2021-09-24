/** Provides classes for modeling pointer wrapper types and expressions. */

private import cpp

/** A class that wraps a pointer type. For example, `std::unique_ptr` and `std::shared_ptr`. */
abstract class PointerWrapper extends Class {
  /**
   * Gets a member function of this class that returns the wrapped pointer, if any.
   *
   * This includes both functions that return the wrapped pointer by value, and functions
   * that return a reference to the pointed-to object.
   */
  abstract MemberFunction getAnUnwrapperFunction();

  /** Holds if the type of the data that is pointed to by this pointer wrapper is `const`. */
  abstract predicate pointsToConst();
}
