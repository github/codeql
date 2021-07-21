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


// FunctionCall predicates:
// getTarget() : Gets the function called by this call.

// inheritated predicate:
// getFile() : Gets the primary file where this element occurs. 

// getName() : Gets the name of this declaration.


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
select call.getFile(), call.getEnclosingFunction().toString(), call, "placeholder"

// Notes
// run this query on rsyslog/rsyslog in LGTM
// result: https://lgtm.com/query/6984839753043321725/
// one result example:
// 	col: /opt/src/action.c 			<--- call.getFile(), https://github.com/rsyslog/rsyslog/blob/master/action.c 
// 	col1: checkExternalStateFile 	<--- call.getEnclosingFunction()
// 	call: call to read 				<--- call
// 		checkExternalStateFile(...):
// 			...
// 			r = read(fd, filebuf, sizeof(filebuf) - 1);
// 			...