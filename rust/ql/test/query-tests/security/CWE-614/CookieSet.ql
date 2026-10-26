import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.security.InsecureCookieExtensions

from DataFlow::Node node, string state, boolean value
where InsecureCookie::cookieSetNode(node, state, value)
select node, state, value
