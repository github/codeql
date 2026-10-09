/**
 * @name Same parameter used as reader and writer in BufferedRWPair
 * @description Use of same parameter as reader and writer in BufferedRWPair.
 * @kind problem
 * @problem.severity warning
 * @id py/bufferedrwpair-undefined-behavior
 * @tags reliability
 *       security
 *       external/cwe/cwe-475
 *       external/cwe/cwe-758
 */

import python

ClassValue requestFunction() { result = Module::named("io").attr("BufferedRWPair") }

from CallNode call, ClassValue func, ControlFlowNode read, ControlFlowNode write
where
  func = requestFunction() and
  func.getACall() = call and
  read = call.getArg(0) and
  write = call.getArg(1) and
  read.pointsTo() = write.pointsTo()
select call, "Using the same reader and writer for BufferedRWPair may cause unexpected behavior"
