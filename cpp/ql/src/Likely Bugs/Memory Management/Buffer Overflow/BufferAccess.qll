import cpp
import semmle.code.cpp.dataflow.TaintTracking
private import semmle.code.cpp.dataflow.RecursionPrevention

/**
 * A buffer which includes an allocation size.
 */
abstract class BufferWithSize extends DataFlow::Node {
  abstract Expr getSizeExpr();

  BufferAccess getAnAccess() {
    any(BufferWithSizeConfig bsc).hasFlow(this, DataFlow::exprNode(result.getPointer()))
  }
}

/** An allocation function. */
abstract class Alloc extends Function { }

/**
 * Allocation functions identified by the QL for C/C++ standard library.
 */
class DefaultAlloc extends Alloc {
  DefaultAlloc() { allocationFunction(this) }
}

/** A buffer created through a call to an allocation function. */
class AllocBuffer extends BufferWithSize {
  FunctionCall call;

  AllocBuffer() {
    asExpr() = call and
    call.getTarget() instanceof Alloc
  }

  override Expr getSizeExpr() { result = call.getArgument(0) }
}

/**
 * Find accesses of buffers for which we have a size expression.
 */
private class BufferWithSizeConfig extends TaintTracking::Configuration {
  BufferWithSizeConfig() { this = "BufferWithSize" }

  override predicate isSource(DataFlow::Node n) { n = any(BufferWithSize b) }

  override predicate isSink(DataFlow::Node n) { n.asExpr() = any(BufferAccess ae).getPointer() }

  override predicate isSanitizer(DataFlow::Node s) {
    s = any(BufferWithSize b) and
    s.asExpr().getControlFlowScope() instanceof Alloc
  }
}

/**
 * An access(read or write) to a buffer, provided as a pair of
 * a pointer to the buffer and the length of data to be read or written.
 * Extend this class to support different kinds of buffer access.
 */
abstract class BufferAccess extends Locatable {
  /** Gets the pointer to the buffer being accessed. */
  abstract Expr getPointer();

  /** Gets the length of the data being read or written by this buffer access. */
  abstract Expr getAccessedLength();
}

/**
 * A buffer access through an array expression.
 */
class ArrayBufferAccess extends BufferAccess, ArrayExpr {
  override Expr getPointer() { result = this.getArrayBase() }

  override Expr getAccessedLength() { result = this.getArrayOffset() }
}

/**
 * A buffer access through an overloaded array expression.
 */
class OverloadedArrayBufferAccess extends BufferAccess, OverloadedArrayExpr {
  override Expr getPointer() { result = this.getQualifier() }

  override Expr getAccessedLength() { result = this.getAnArgument() }
}

/**
 * A buffer access through pointer arithmetic.
 */
class PointerArithmeticAccess extends BufferAccess, Expr {
  PointerArithmeticOperation p;

  PointerArithmeticAccess() {
    this = p and
    p.getAnOperand().getType().getUnspecifiedType() instanceof IntegralType and
    not p.getParent() instanceof ComparisonOperation
  }

  override Expr getPointer() {
    result = p.getAnOperand() and
    result.getType().getUnspecifiedType() instanceof PointerType
  }

  override Expr getAccessedLength() {
    result = p.getAnOperand() and
    result.getType().getUnspecifiedType() instanceof IntegralType
  }
}

/**
 * A pair of buffer accesses through a call to memcpy.
 */
class MemCpy extends BufferAccess, FunctionCall {
  MemCpy() { getTarget().hasName("memcpy") }

  override Expr getPointer() {
    result = getArgument(0) or
    result = getArgument(1)
  }

  override Expr getAccessedLength() { result = getArgument(2) }
}

class StrncpySizeExpr extends BufferAccess, FunctionCall {
  StrncpySizeExpr() { getTarget().hasName("strncpy") }

  override Expr getPointer() {
    result = getArgument(0) or
    result = getArgument(1)
  }

  override Expr getAccessedLength() { result = getArgument(2) }
}

class RecvSizeExpr extends BufferAccess, FunctionCall {
  RecvSizeExpr() { getTarget().hasName("recv") }

  override Expr getPointer() { result = getArgument(1) }

  override Expr getAccessedLength() { result = getArgument(2) }
}

class SendSizeExpr extends BufferAccess, FunctionCall {
  SendSizeExpr() { getTarget().hasName("send") }

  override Expr getPointer() { result = getArgument(1) }

  override Expr getAccessedLength() { result = getArgument(2) }
}

class SnprintfSizeExpr extends BufferAccess, FunctionCall {
  SnprintfSizeExpr() { getTarget().hasName("snprintf") }

  override Expr getPointer() { result = getArgument(0) }

  override Expr getAccessedLength() { result = getArgument(1) }
}

class MemcmpSizeExpr extends BufferAccess, FunctionCall {
  MemcmpSizeExpr() { getTarget().hasName("Memcmp") }

  override Expr getPointer() {
    result = getArgument(0) or
    result = getArgument(1)
  }

  override Expr getAccessedLength() { result = getArgument(2) }
}

class MallocSizeExpr extends BufferAccess, FunctionCall {
  MallocSizeExpr() { getTarget().hasName("malloc") }

  override Expr getPointer() { none() }

  override Expr getAccessedLength() { result = getArgument(1) }
}
