/**
 * Provides models for Swift pointer types including `UnsafePointer`,
 * `UnsafeBufferPointer` and similar types.
 */

import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.dataflow.ExternalFlow
private import codeql.swift.dataflow.FlowSteps

/**
 * A Swift unsafe typed pointer type such as `UnsafePointer`,
 * `UnsafeMutablePointer` or `UnsafeBufferPointer`.
 */
class UnsafeTypedPointerType extends BoundGenericType {
  UnsafeTypedPointerType() { this.getName().regexpMatch("Unsafe(Mutable|)(Buffer|)Pointer<.*") }
}

/**
 * A Swift unsafe raw pointer type such as `UnsafeRawPointer`,
 * `UnsafeMutableRawPointer` or `UnsafeRawBufferPointer`.
 */
class UnsafeRawPointerType extends NominalType {
  UnsafeRawPointerType() { this.getName().regexpMatch("Unsafe(Mutable|)Raw(Buffer|)Pointer") }
}

/**
 * A Swift `OpaquePointer`.
 */
class OpaquePointerType extends NominalType {
  OpaquePointerType() { this.getName() = "OpaquePointer" }
}

/**
 * A Swift `AutoreleasingUnsafeMutablePointer`.
 */
class AutoreleasingUnsafeMutablePointerType extends BoundGenericType {
  AutoreleasingUnsafeMutablePointerType() {
    this.getName().matches("AutoreleasingUnsafeMutablePointer<%")
  }
}

/**
 * A Swift `Unmanaged` object reference.
 */
class UnmanagedType extends BoundGenericType {
  UnmanagedType() { this.getName().matches("Unmanaged<%") }
}

/**
 * A Swift `CVaListPointer`.
 */
class CVaListPointerType extends NominalType {
  CVaListPointerType() { this.getName() = "CVaListPointer" }
}

/**
 * A Swift `ManagedBufferPointer`.
 */
class ManagedBufferPointerType extends BoundGenericType {
  ManagedBufferPointerType() { this.getName().matches("ManagedBufferPointer<%") }
}

/**
 * A model for `UnsafePointer` and related Swift class members that permit taint flow.
 */
private class PointerSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";UnsafePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeMutablePointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutablePointer;true;init(_:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.CollectionElement;value",
        ";UnsafeMutablePointer;true;init(mutating:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutablePointer;true;init(mutating:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.CollectionElement;value",
        ";UnsafeMutablePointer;true;assign(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;assign(repeating:count:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;initialize(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;initialize(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;initialize(repeating:count:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;initialize(to:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;initialize(to:count:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;move();;;Argument[-1].CollectionElement;ReturnValue;value",
        ";UnsafeMutablePointer;true;moveAssign(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;moveInitialize(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;moveUpdate(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;update(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;update(repeating:count:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeBufferPointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeBufferPointer;true;init(rebasing:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeBufferPointer;true;init(start:count:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeMutableBufferPointer;true;init(mutating:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;init(rebasing:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;init(start:count:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;assign(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;initialize(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;initialize(from:);;;Argument[0].CollectionElement;ReturnValue.TupleElement[0].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;initialize(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;initialize(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;initializeElement(at:to:);;;Argument[1];Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;moveElement(from:);;;Argument[-1].CollectionElement;ReturnValue;value",
        ";UnsafeMutableBufferPointer;true;moveInitialize(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;moveUpdate(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;update(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;update(from:);;;Argument[0].CollectionElement;ReturnValue.TupleElement[0].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;update(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;update(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeRawPointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeRawPointer;true;init(_:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.CollectionElement;value",
        ";UnsafeRawPointer;true;alignedDown(for:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;alignedDown(toMultipleOf:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;alignedUp(for:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;alignedUp(toMultipleOf:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;load(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeRawPointer;true;loadUnaligned(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";UnsafeRawPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;bindMemory(to:capacity:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeMutableRawPointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableRawPointer;true;init(_:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.CollectionElement;value",
        ";UnsafeMutableRawPointer;true;init(mutating:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableRawPointer;true;init(mutating:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.OptionalSome.CollectionElement;value",
        ";UnsafeMutableRawPointer;true;alignedDown(for:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;alignedDown(toMultipleOf:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;alignedUp(for:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;alignedUp(toMultipleOf:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;copyBytes(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;copyMemory(from:count:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:at:count:to:);;;Argument[3];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:at:count:to:);;;Argument[3];ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:from:count:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:from:count:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:repeating:count:);;;Argument[1];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:repeating:count:);;;Argument[1];ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:to:);;;Argument[1];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;initializeMemory(as:to:);;;Argument[1];ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;load(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeMutableRawPointer;true;loadUnaligned(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeMutableRawPointer;true;moveInitializeMemory(as:from:count:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;moveInitializeMemory(as:from:count:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;storeBytes(of:toByteOffset:as:);;;Argument[0];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";UnsafeMutableRawPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;bindMemory(to:capacity:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeRawBufferPointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeRawBufferPointer;true;init(rebasing:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeRawBufferPointer;true;init(start:count:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawBufferPointer;true;load(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeRawBufferPointer;true;loadUnaligned(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";UnsafeRawBufferPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawBufferPointer;true;bindMemory(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeMutableRawBufferPointer;true;init(_:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableRawBufferPointer;true;init(mutating:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableRawBufferPointer;true;init(rebasing:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";UnsafeMutableRawBufferPointer;true;init(start:count:);;;Argument[0].OptionalSome.CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;copyBytes(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableRawBufferPointer;true;copyMemory(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;ReturnValue.TupleElement[0,1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;ReturnValue.TupleElement[0,1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:repeating:);;;Argument[1];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;initializeMemory(as:repeating:);;;Argument[1];ReturnValue.TupleElement[0,1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;load(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeMutableRawBufferPointer;true;loadUnaligned(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";UnsafeMutableRawBufferPointer;true;moveInitializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;moveInitializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;storeBytes(of:toByteOffset:as:);;;Argument[0];Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";UnsafeMutableRawBufferPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;bindMemory(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";Slice;true;init(base:bounds:);;;Argument[0].CollectionElement;ReturnValue.CollectionElement;value",
        ";Slice;true;copyBytes(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;initialize(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;initialize(from:);;;Argument[0].CollectionElement;ReturnValue.TupleElement[0,1].CollectionElement;taint",
        ";Slice;true;initialize(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;initialize(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Slice;true;initializeElement(at:to:);;;Argument[1];Argument[-1].CollectionElement;value",
        ";Slice;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;initializeMemory(as:from:);;;Argument[1].CollectionElement;ReturnValue.TupleElement[0,1].CollectionElement;taint",
        ";Slice;true;initializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;initializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Slice;true;initializeMemory(as:repeating:);;;Argument[1];Argument[-1].CollectionElement;taint",
        ";Slice;true;initializeMemory(as:repeating:);;;Argument[1];ReturnValue.CollectionElement;taint",
        ";Slice;true;insert(_:at:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Slice;true;insert(contentsOf:at:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;load(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";Slice;true;loadUnaligned(fromByteOffset:as:);;;Argument[-1].CollectionElement;ReturnValue;taint",
        ";Slice;true;moveElement(from:);;;Argument[-1].CollectionElement;ReturnValue;value",
        ";Slice;true;moveInitialize(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;moveInitializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;moveInitializeMemory(as:fromContentsOf:);;;Argument[1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Slice;true;moveUpdate(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;remove(at:);;;Argument[-1].CollectionElement;ReturnValue;value",
        ";Slice;true;replaceSubrange(_:with:);;;Argument[1].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;storeBytes(of:toByteOffset:as:);;;Argument[0];Argument[-1].CollectionElement;taint",
        ";Slice;true;update(from:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;update(from:);;;Argument[0].CollectionElement;ReturnValue.TupleElement[0].CollectionElement;taint",
        ";Slice;true;update(fromContentsOf:);;;Argument[0].CollectionElement;Argument[-1].CollectionElement;value",
        ";Slice;true;update(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";Slice;true;withContiguousMutableStorageIfAvailable(to:_:);;;Argument[-1].CollectionElement;Argument[0].Parameter[0].CollectionElement;taint",
        ";Slice;true;withContiguousMutableStorageIfAvailable(to:_:);;;Argument[0].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;withContiguousMutableStorageIfAvailable(to:_:);;;Argument[0].ReturnValue;ReturnValue;value",
        ";Slice;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";Slice;true;withMemoryRebound(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";Slice;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";Slice;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";Slice;true;bindMemory(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";;false;withUnsafePointer(to:_:);;;Argument[0];Argument[1].Parameter[0].CollectionElement;taint",
        ";;false;withUnsafePointer(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";;false;withUnsafeMutablePointer(to:_:);;;Argument[0];Argument[1].Parameter[0].CollectionElement;taint",
        ";;false;withUnsafeMutablePointer(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[0];value",
        ";;false;withUnsafeMutablePointer(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";;false;withUnsafeBytes(of:_:);;;Argument[0];Argument[1].Parameter[0].CollectionElement;taint",
        ";;false;withUnsafeBytes(of:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";;false;withUnsafeMutableBytes(of:_:);;;Argument[0];Argument[1].Parameter[0].CollectionElement;taint",
        ";;false;withUnsafeMutableBytes(of:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[0];taint",
        ";;false;withUnsafeMutableBytes(of:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";;false;withUnsafeTemporaryAllocation(of:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";;false;withUnsafeTemporaryAllocation(byteCount:alignment:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";;false;withExtendedLifetime(_:_:);;;Argument[1].ReturnValue;ReturnValue;value",
      ]
  }
}
