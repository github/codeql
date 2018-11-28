/**
 * @name Default version of SSL/TLS may be insecure
 * @description No SSL/TLS version has been specified in a call to 'ssl.wrap_socket'.
 *              This may result in an insecure protocol being used.
 * @id py/insecure-default-protocol
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @tags security
 *       external/cwe/cwe-327
 */

import python

FunctionObject ssl_wrap_socket() {
    result = any(ModuleObject ssl | ssl.getName() = "ssl").getAttribute("wrap_socket")
}

from CallNode call
where 
    call = ssl_wrap_socket().getACall() and
    not exists(call.getArgByName("ssl_version"))
select call, "Call to ssl.wrap_socket does not specify a protocol, which may result in an insecure default being used."




