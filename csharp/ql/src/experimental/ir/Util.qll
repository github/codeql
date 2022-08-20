/**
 * Temporary file that has stubs for various functionalities in the IR conversion.
 */

import csharp

class ArrayInitWithMod extends ArrayInitializer {
  predicate isInitialized(int entry) { entry in [0 .. this.getNumberOfElements() - 1] }

  predicate isValueInitialized(int elementIndex) {
    this.isInitialized(elementIndex) and
    not exists(this.getElement(elementIndex))
  }
}

class ObjectInitializerMod extends ObjectInitializer {
  private predicate isInitialized(Field field) {
    not field.isReadOnly() and // TODO: Is this the only instance whena field can not be init?
    this.getAMemberInitializer().getTargetVariable() = field
  }

  predicate isValueInitialized(Field field) {
    this.isInitialized(field) and
    not field = this.getAMemberInitializer().getInitializedMember()
  }
}

// TODO: See if we need to adapt this for C#
abstract class SideEffectFunction extends Callable {
  /**
   * Holds if the function never reads from memory that was defined before entry to the function.
   * This memory could be from global variables, or from other memory that was reachable from a
   * pointer that was passed into the function.
   */
  abstract predicate neverReadsMemory();

  /**
   * Holds if the function never writes to memory that remains allocated after the function
   * returns. This memory could be from global variables, or from other memory that was reachable
   * from a pointer that was passed into the function.
   */
  abstract predicate neverWritesMemory();
}
