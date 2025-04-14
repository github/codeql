import cpp

/**
 * Returns the size of the pointed-to type, counting void types as size 1.
 */
int getPointedSize(Type t) {
  result = t.getUnspecifiedType().(PointerType).getBaseType().getSize().maximum(1)
}

/**
 * An operation that reads data from or writes data to a buffer.
 *
 * See the BufferWrite class for an explanation of how BufferAccess and
 * BufferWrite differ.
 */
abstract class BufferAccess extends Expr {
  BufferAccess() {
    not this.isUnevaluated() and
    //A buffer access must be reachable (not in dead code)
    reachable(this)
  }

  abstract string getName();

  /**
   * Gets the expression that denotes the buffer, along with a textual label
   * for it and an access type.
   *
   * accessType:
   * - 1 = buffer range [0, getSize) is accessed entirely.
   * - 2 = buffer range [0, getSize) may be accessed partially or entirely.
   * - 3 = buffer is accessed at offset getSize - 1.
   * - 4 = buffer is accessed with null terminator read protections
   *       (does not read past null terminator, regardless of access size)
   */
  abstract Expr getBuffer(string bufferDesc, int accessType);

  /**
   * Gets the expression that represents the size of the buffer access. The
   * actual size is typically the value of this expression multiplied by the
   * result of `getSizeMult()`, in bytes.
   */
  Expr getSizeExpr() { none() }

  /**
   * Gets a constant multiplier for the buffer access size given by
   * `getSizeExpr`, in bytes.
   */
  int getSizeMult() { none() }

  /**
   * Gets the buffer access size in bytes.
   */
  int getSize() { result = this.getSizeExpr().getValue().toInt() * this.getSizeMult() }
}

/**
 * Calls to memcpy and similar functions.
 *  memcpy(dest, src, num)
 *  wmemcpy(dest, src, num)
 *  memmove(dest, src, num)
 *  wmemmove(dest, src, num)
 *  mempcpy(dest, src, num)
 *  wmempcpy(dest, src, num)
 *  RtlCopyMemoryNonTemporal(dest, src, num)
 */
class MemcpyBA extends BufferAccess {
  MemcpyBA() {
    this.(FunctionCall).getTarget().getName() =
      [
        "memcpy", "wmemcpy", "memmove", "wmemmove", "mempcpy", "wmempcpy",
        "RtlCopyMemoryNonTemporal"
      ]
  }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 1
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "source buffer" and
    accessType = 1
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to bcopy.
 *  bcopy(src, dest, num)
 */
class BCopyBA extends BufferAccess {
  BCopyBA() { this.(FunctionCall).getTarget().getName() = "bcopy" }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "source buffer" and
    accessType = 1
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "destination buffer" and
    accessType = 1
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to strncpy.
 *  strncpy(dest, src, num)
 */
class StrncpyBA extends BufferAccess {
  StrncpyBA() { this.(FunctionCall).getTarget().getName() = "strncpy" }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 2
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "source buffer" and
    accessType = 4
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to memccpy.
 *  memccpy(dest, src, c, n)
 */
class MemccpyBA extends BufferAccess {
  MemccpyBA() { this.(FunctionCall).getTarget().getName() = "memccpy" }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 2
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "source buffer" and
    accessType = 2
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(3) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to memcmp and similar functions.
 *  memcmp(buffer1, buffer2, num)
 *  wmemcmp(buffer1, buffer2, num)
 *  _memicmp(buffer1, buffer2, count)
 *  _memicmp_l(buffer1, buffer2, count, locale)
 */
class MemcmpBA extends BufferAccess {
  MemcmpBA() {
    this.(FunctionCall).getTarget().getName() = ["memcmp", "wmemcmp", "_memicmp", "_memicmp_l"]
  }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "first buffer" and
    accessType = 2
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "second buffer" and
    accessType = 2
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to swab and similar functions.
 *  swab(src, dest, num)
 *  _swab(src, dest, num)
 */
class SwabBA extends BufferAccess {
  SwabBA() { this.(FunctionCall).getTarget().getName() = ["swab", "_swab"] }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "source buffer" and
    accessType = 1
    or
    result = this.(FunctionCall).getArgument(1) and
    bufferDesc = "destination buffer" and
    accessType = 1
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to memset and similar functions.
 *  memset(dest, value, num)
 *  wmemset(dest, value, num)
 */
class MemsetBA extends BufferAccess {
  MemsetBA() { this.(FunctionCall).getTarget().getName() = ["memset", "wmemset"] }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 1
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to `RtlSecureZeroMemory`.
 *  RtlSecureZeroMemory(ptr, cnt)
 */
class ZeroMemoryBA extends BufferAccess {
  ZeroMemoryBA() { this.(FunctionCall).getTarget().getName() = "RtlSecureZeroMemory" }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 1
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(1) }

  override int getSizeMult() { result = 1 }
}

/**
 * Calls to memchr and similar functions.
 *  memchr(buffer, value, num)
 *  wmemchr(buffer, value, num)
 */
class MemchrBA extends BufferAccess {
  MemchrBA() { this.(FunctionCall).getTarget().getName() = ["memchr", "wmemchr"] }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "source buffer" and
    accessType = 2
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(2) }

  override int getSizeMult() {
    result = getPointedSize(this.(FunctionCall).getTarget().getParameter(0).getType())
  }
}

/**
 * Calls to fread.
 *  fread(buffer, size, number, file)
 */
class FreadBA extends BufferAccess {
  FreadBA() { this.(FunctionCall).getTarget().getName() = "fread" }

  override string getName() { result = this.(FunctionCall).getTarget().getName() }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(FunctionCall).getArgument(0) and
    bufferDesc = "destination buffer" and
    accessType = 2
  }

  override Expr getSizeExpr() { result = this.(FunctionCall).getArgument(1) }

  override int getSizeMult() { result = this.(FunctionCall).getArgument(2).getValue().toInt() }
}

/**
 * A array access on a buffer:
 *  buffer[ix]
 * but not:
 *  &buffer[ix]
 */
class ArrayExprBA extends BufferAccess, ArrayExpr {
  ArrayExprBA() {
    not exists(AddressOfExpr aoe | aoe.getAChild() = this) and
    // exclude accesses in macro implementation of `strcmp`,
    // which are carefully controlled but can look dangerous.
    not exists(Macro m |
      m.getName() = "strcmp" and
      m.getAnInvocation().getAnExpandedElement() = this
    )
  }

  override string getName() { result = "array indexing" }

  override Expr getBuffer(string bufferDesc, int accessType) {
    result = this.(ArrayExpr).getArrayBase() and
    bufferDesc = "array" and
    accessType = 3
  }

  override Expr getSizeExpr() { result = this.(ArrayExpr).getArrayOffset() }

  override int getSize() {
    // byte size of the buffer that would be required to support this
    // access
    result = (1 + this.getSizeExpr().getValue().toInt()) * this.getSizeMult()
  }

  override int getSizeMult() { result = this.(ArrayExpr).getType().getSize() }
}
