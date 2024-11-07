/**
 * @name Call to memory access function may overflow buffer
 * @description Incorrect use of a function that accesses a memory
 *              buffer may read or write data past the end of that
 *              buffer.
 * @kind problem
 * @id cpp/overflow-buffer
 * @problem.severity recommendation
 * @security-severity 9.3
 * @tags security
 *       external/cwe/cwe-119
 *       external/cwe/cwe-121
 *       external/cwe/cwe-122
 *       external/cwe/cwe-126
 */

import semmle.code.cpp.security.BufferWrite
import semmle.code.cpp.security.BufferAccess

bindingset[num, singular, plural]
string plural(int num, string singular, string plural) {
  if num = 1 then result = num + singular else result = num + plural
}

from
  BufferAccess ba, string bufferDesc, int accessSize, int accessType, Element bufferAlloc,
  int bufferSize, string message
where
  accessType != 4 and
  accessSize = ba.getSize() and
  bufferSize = getBufferSize(ba.getBuffer(bufferDesc, accessType), bufferAlloc) and
  (
    accessSize > bufferSize
    or
    accessSize <= 0 and accessType = 3
  ) and
  if accessType = 1
  then
    message =
      "This '" + ba.getName() + "' operation accesses " + plural(accessSize, " byte", " bytes") +
        " but the $@ is only " + plural(bufferSize, " byte", " bytes") + "."
  else
    if accessType = 2
    then
      message =
        "This '" + ba.getName() + "' operation may access " + plural(accessSize, " byte", " bytes") +
          " but the $@ is only " + plural(bufferSize, " byte", " bytes") + "."
    else (
      if accessSize > 0
      then
        message =
          "This array indexing operation accesses byte offset " + (accessSize - 1) +
            " but the $@ is only " + plural(bufferSize, " byte", " bytes") + "."
      else
        message =
          "This array indexing operation accesses a negative index " +
            ((accessSize / ba.getActualType().getSize()) - 1) + " on the $@."
    )
select ba, message, bufferAlloc, bufferDesc
