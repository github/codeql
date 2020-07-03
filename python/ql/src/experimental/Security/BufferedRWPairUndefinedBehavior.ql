/**
 * @name Same parameter used as reader and writer in BufferedRWPair
 * @description Use of same parameter as reader and writer in BufferedRWPair.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id python/bufferedrwpair-undefined-behavior
 * @tags reliability
 *       security
 */

import python

ClassValue requestFunction() { result = Module::named("io").attr("BufferedRWPair") }

from CallNode call, ClassValue func, ControlFlowNode read, ControlFlowNode write
where
  func = requestFunction() and
  func.getACall() = call and
  read = call.getArg(0) and
  write = call.getArg(1) and
  read.getNode().toString() = write.getNode().toString()
select call, "BufferedRWPair does not attempt to synchronize accesses to its underlying raw streams"
