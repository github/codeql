/**
 * @name Discovering program input
 * @description https://securitylab.github.com/research/bug-hunting-codeql-rsyslog/
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/discover-input
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