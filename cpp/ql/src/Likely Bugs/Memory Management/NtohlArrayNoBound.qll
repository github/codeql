import cpp
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/**
 * An access (read or write) to a buffer, provided as a pair of
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
  MemCpy() { this.getTarget().hasName("memcpy") }

  override Expr getPointer() {
    result = this.getArgument(0) or
    result = this.getArgument(1)
  }

  override Expr getAccessedLength() { result = this.getArgument(2) }
}

class StrncpySizeExpr extends BufferAccess, FunctionCall {
  StrncpySizeExpr() { this.getTarget().hasName("strncpy") }

  override Expr getPointer() {
    result = this.getArgument(0) or
    result = this.getArgument(1)
  }

  override Expr getAccessedLength() { result = this.getArgument(2) }
}

class RecvSizeExpr extends BufferAccess, FunctionCall {
  RecvSizeExpr() { this.getTarget().hasName("recv") }

  override Expr getPointer() { result = this.getArgument(1) }

  override Expr getAccessedLength() { result = this.getArgument(2) }
}

class SendSizeExpr extends BufferAccess, FunctionCall {
  SendSizeExpr() { this.getTarget().hasName("send") }

  override Expr getPointer() { result = this.getArgument(1) }

  override Expr getAccessedLength() { result = this.getArgument(2) }
}

class SnprintfSizeExpr extends BufferAccess, FunctionCall {
  SnprintfSizeExpr() { this.getTarget().hasName("snprintf") }

  override Expr getPointer() { result = this.getArgument(0) }

  override Expr getAccessedLength() { result = this.getArgument(1) }
}

class MemcmpSizeExpr extends BufferAccess, FunctionCall {
  MemcmpSizeExpr() { this.getTarget().hasName("memcmp") }

  override Expr getPointer() {
    result = this.getArgument(0) or
    result = this.getArgument(1)
  }

  override Expr getAccessedLength() { result = this.getArgument(2) }
}

class MallocSizeExpr extends BufferAccess, FunctionCall {
  MallocSizeExpr() { this.getTarget().hasName("malloc") }

  override Expr getPointer() { none() }

  override Expr getAccessedLength() { result = this.getArgument(0) }
}

class NetworkFunctionCall extends FunctionCall {
  NetworkFunctionCall() { this.getTarget().hasName(["ntohd", "ntohf", "ntohl", "ntohll", "ntohs"]) }
}

private module NetworkToBufferSizeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof NetworkFunctionCall }

  predicate isSink(DataFlow::Node node) { node.asExpr() = any(BufferAccess ba).getAccessedLength() }

  predicate isBarrier(DataFlow::Node node) {
    exists(GuardCondition gc, GVN gvn |
      gc.getAChild*() = gvn.getAnExpr() and
      globalValueNumber(node.asExpr()) = gvn and
      gc.controls(node.asExpr().getBasicBlock(), _)
    )
  }
}

module NetworkToBufferSizeFlow = DataFlow::Global<NetworkToBufferSizeConfig>;
