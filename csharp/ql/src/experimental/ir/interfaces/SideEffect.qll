private import csharp as CSharp

/**
 * Models the side effects of a library function.
 */
abstract class SideEffectFunction extends CSharp::Callable {
  /**
   * Holds if the function never reads from memory that was defined before entry to the function.
   * This memory could be from global variables, or from other memory that was reachable from a
   * pointer that was passed into the function. Input side-effects, and reads from memory that
   * cannot be visible to the caller (for example a buffer inside an I/O library) are not modeled
   * here.
   */
  abstract predicate hasOnlySpecificReadSideEffects();

  /**
   * Holds if the function never writes to memory that remains allocated after the function
   * returns. This memory could be from global variables, or from other memory that was reachable
   * from a pointer that was passed into the function. Output side-effects, and writes to memory
   * that cannot be visible to the caller (for example a buffer inside an I/O library) are not
   * modeled here.
   */
  abstract predicate hasOnlySpecificWriteSideEffects();
}
