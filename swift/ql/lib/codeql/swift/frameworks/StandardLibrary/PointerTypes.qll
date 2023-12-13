/**
 * Provides models for Swift pointer types including `UnsafePointer`,
 * `UnsafeBufferPointer` and similar types.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

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
        ";UnsafeMutablePointer;true;init(mutating:);;;Argument[0];ReturnValue;taint",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutablePointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeMutableBufferPointer;true;update(repeating:);;;Argument[0];Argument[-1].CollectionElement;value",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        // ---
        ";UnsafeRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";UnsafeRawPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawPointer;true;bindMemory(to:capacity:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[-1].CollectionElement;Argument[2].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;withMemoryRebound(to:capacity:_:);;;Argument[2].ReturnValue;ReturnValue;value",
        ";UnsafeMutableRawPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawPointer;true;bindMemory(to:capacity:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";UnsafeRawBufferPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeRawBufferPointer;true;bindMemory(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[-1].CollectionElement;Argument[1].Parameter[0].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].Parameter[0].CollectionElement;Argument[-1].CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;withMemoryRebound(to:_:);;;Argument[1].ReturnValue;ReturnValue;value",
        ";UnsafeMutableRawBufferPointer;true;assumingMemoryBound(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        ";UnsafeMutableRawBufferPointer;true;bindMemory(to:);;;Argument[-1].CollectionElement;ReturnValue.CollectionElement;taint",
        // ---
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
