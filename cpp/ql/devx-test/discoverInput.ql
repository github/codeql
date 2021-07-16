/**
 * @name Discovering program input
 * @description Blocks with too many consecutive statements are candidates for refactoring. Only complex statements are counted here (eg. for, while, switch ...). The top-level logic will be clearer if each complex statement is extracted to a function.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/complex-block
 * @tags testability
 *       readability
 *       maintainability
 */

import cpp

class ReadFunctionCall extends FunctionCall {
	ReadFunctionCall() {
		this.getTarget().getName() = "pread" or
		this.getTarget().getName() = "read" or
		this.getTarget().getName() = "readv" or
		this.getTarget().getName() = "recvfrom" or
		this.getTarget().getName() = "recvmsg" or
		this.getTarget().getName() = "recv"
	}
}

from ReadFunctionCall call
select call.getFile(), call.getEnclosingFunction(), call