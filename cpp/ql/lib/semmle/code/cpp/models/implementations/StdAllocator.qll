/**
 * Provides models for C++ `allocator` and `allocator_traits` classes.
 */

import semmle.code.cpp.models.interfaces.SideEffect
import semmle.code.cpp.models.interfaces.Alias

/** The `std::allocator` class. */
class StdAllocator extends Class {
  StdAllocator() { this.hasGlobalOrStdOrBslName("allocator") }
}

/** The `std::allocator_traits` class. */
class StdAllocatorTraits extends Class {
  StdAllocatorTraits() { this.hasGlobalOrStdOrBslName("allocator_traits") }
}

private class StdAllocatorConstructor extends Constructor, AliasFunction, SideEffectFunction {
  StdAllocatorConstructor() { this.getDeclaringType() instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and
    buffer = false and
    mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }
}

private class StdAllocatorDestructor extends Destructor, AliasFunction, SideEffectFunction {
  StdAllocatorDestructor() { this.getDeclaringType() instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = -1 and
    buffer = false and
    mustWrite = true
  }
}

private class StdAllocatorAddress extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorAddress() { this.getClassAndName("address") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class StdAllocatorAllocate extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorAllocate() { this.getClassAndName("allocate") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class StdAllocatorTraitsAllocate extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorTraitsAllocate() {
    this.getClassAndName(["allocate", "allocate_at_least"]) instanceof StdAllocatorTraits
  }

  override predicate parameterNeverEscapes(int index) {
    this.getParameter(index).getUnspecifiedType() instanceof ReferenceType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }
}

private class StdAllocatorDeallocate extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorDeallocate() { this.getClassAndName("deallocate") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and
    buffer = false and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and
    buffer = false
  }
}

private class StdAllocatorTraitsDeallocate extends MemberFunction, AliasFunction, SideEffectFunction
{
  StdAllocatorTraitsDeallocate() {
    this.getClassAndName("deallocate") instanceof StdAllocatorTraits
  }

  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and
    buffer = false and
    mustWrite = false
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = [0, 1] and
    buffer = false
  }
}

private class StdAllocatorMaxSize extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorMaxSize() { this.getClassAndName("max_size") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class StdAllocatTraitsMaxSize extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatTraitsMaxSize() { this.getClassAndName("max_size") instanceof StdAllocatorTraits }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }
}

private class StdAllocatorConstruct extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorConstruct() { this.getClassAndName("construct") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and buffer = false
  }
}

class StdAllocatorTraitsConstruct extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorTraitsConstruct() { this.getClassAndName("construct") instanceof StdAllocatorTraits }

  override predicate parameterNeverEscapes(int index) {
    index = 1 or this.getParameter(index).getUnspecifiedType() instanceof ReferenceType
  }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    this.getParameter(i).getUnspecifiedType() instanceof ReferenceType and
    buffer = false
  }
}

class StdAllocatorDestroy extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorDestroy() { this.getClassAndName("destroy") instanceof StdAllocator }

  override predicate parameterNeverEscapes(int index) { index = -1 }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 0 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = false
  }
}

class StdAllocatorTraitsDestroy extends MemberFunction, AliasFunction, SideEffectFunction {
  StdAllocatorTraitsDestroy() { this.getClassAndName("destroy") instanceof StdAllocatorTraits }

  override predicate parameterNeverEscapes(int index) { index = [0, 1] }

  override predicate parameterEscapesOnlyViaReturn(int index) { none() }

  override predicate hasOnlySpecificReadSideEffects() { any() }

  override predicate hasOnlySpecificWriteSideEffects() { any() }

  override predicate hasSpecificWriteSideEffect(ParameterIndex i, boolean buffer, boolean mustWrite) {
    i = 1 and buffer = false and mustWrite = true
  }

  override predicate hasSpecificReadSideEffect(ParameterIndex i, boolean buffer) {
    i = 0 and buffer = false
  }
}
