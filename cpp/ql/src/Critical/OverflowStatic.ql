/**
 * @name Static array access may cause overflow
 * @description Exceeding the size of a static array during write or access operations
 *              may result in a buffer overflow.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/static-buffer-overflow
 * @tags reliability
 *       security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-131
 */

import cpp
import semmle.code.cpp.commons.Buffer
import LoopBounds

private predicate staticBufferBase(VariableAccess access, Variable v) {
  v.getType().(ArrayType).getBaseType() instanceof CharType and
  access = v.getAnAccess() and
  not memberMayBeVarSize(_, v)
}

predicate staticBuffer(VariableAccess access, Variable v, int size) {
  staticBufferBase(access, v) and
  size = getBufferSize(access, _)
}

class BufferAccess extends ArrayExpr {
  BufferAccess() {
    exists(int size |
      staticBuffer(this.getArrayBase(), _, size) and
      size != 0
    ) and
    // exclude accesses in macro implementation of `strcmp`,
    // which are carefully controlled but can look dangerous.
    not exists(Macro m |
      m.getName() = "strcmp" and
      m.getAnInvocation().getAnExpandedElement() = this
    )
  }

  int bufferSize() { staticBuffer(this.getArrayBase(), _, result) }

  Variable buffer() { result.getAnAccess() = this.getArrayBase() }
}

predicate overflowOffsetInLoop(BufferAccess bufaccess, string msg) {
  exists(ClassicForLoop loop |
    loop.getStmt().getAChild*() = bufaccess.getEnclosingStmt() and
    loop.limit() >= bufaccess.bufferSize() and
    loop.counter().getAnAccess() = bufaccess.getArrayOffset() and
    msg =
      "Potential buffer-overflow: counter '" + loop.counter().toString() + "' <= " +
        loop.limit().toString() + " but '" + bufaccess.buffer().getName() + "' has " +
        bufaccess.bufferSize().toString() + " elements."
  )
}

predicate bufferAndSizeFunction(Function f, int buf, int size) {
  f.hasGlobalName("read") and buf = 1 and size = 2
  or
  f.hasGlobalOrStdName("fgets") and buf = 0 and size = 1
  or
  f.hasGlobalOrStdName("strncpy") and buf = 0 and size = 2
  or
  f.hasGlobalOrStdName("strncat") and buf = 0 and size = 2
  or
  f.hasGlobalOrStdName("memcpy") and buf = 0 and size = 2
  or
  f.hasGlobalOrStdName("memmove") and buf = 0 and size = 2
  or
  f.hasGlobalOrStdName("snprintf") and buf = 0 and size = 1
  or
  f.hasGlobalOrStdName("vsnprintf") and buf = 0 and size = 1
}

class CallWithBufferSize extends FunctionCall {
  CallWithBufferSize() { bufferAndSizeFunction(this.getTarget(), _, _) }

  Expr buffer() {
    exists(int i |
      bufferAndSizeFunction(this.getTarget(), i, _) and
      result = this.getArgument(i)
    )
  }

  Expr statedSizeExpr() {
    exists(int i |
      bufferAndSizeFunction(this.getTarget(), _, i) and
      result = this.getArgument(i)
    )
  }

  int statedSizeValue() {
    exists(Expr statedSizeSrc |
      DataFlow::localExprFlow(statedSizeSrc, statedSizeExpr()) and
      result = statedSizeSrc.getValue().toInt()
    )
  }
}

predicate wrongBufferSize(Expr error, string msg) {
  exists(CallWithBufferSize call, int bufsize, Variable buf, int statedSize |
    staticBuffer(call.buffer(), buf, bufsize) and
    statedSize = min(call.statedSizeValue()) and
    statedSize > bufsize and
    error = call.statedSizeExpr() and
    msg =
      "Potential buffer-overflow: '" + buf.getName() + "' has size " + bufsize.toString() + " not " +
        statedSize + "."
  )
}

predicate outOfBounds(BufferAccess bufaccess, string msg) {
  exists(int size, int access, string buf |
    buf = bufaccess.buffer().getName() and
    bufaccess.bufferSize() = size and
    bufaccess.getArrayOffset().getValue().toInt() = access and
    (
      access > size
      or
      access = size and not exists(AddressOfExpr addof | bufaccess = addof.getOperand())
    ) and
    msg =
      "Potential buffer-overflow: '" + buf + "' has size " + size.toString() + " but '" + buf + "[" +
        access.toString() + "]' is accessed here."
  )
}

from Element error, string msg
where
  overflowOffsetInLoop(error, msg) or
  wrongBufferSize(error, msg) or
  outOfBounds(error, msg)
select error, msg
