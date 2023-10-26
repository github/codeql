/**
 * @name CORS misconfiguration
 * @description If a CORS policy is configured to accept an origin value obtained from the request data,
 * 				or is set to `null`, and it allows credential sharing, then the users of the
 * 				application are vulnerable to the same range of attacks as in XSS (credential stealing, etc.).
 * @kind problem
 * @problem.severity warning
 * @id go/cors-misconfiguration
 * @tags security
 *       experimental
 *       external/cwe/cwe-942
 *       external/cwe/cwe-346
 */

import go

// from GinCors::New n, GinCors::Config cfg, DataFlow::CallNode c
// //where n.getACall() = c and c.getArgument(0) = cfg
// where cfg.getAllowCredentials() = "*"
// select cfg, "hello"

from GinCors::GinConfig gc
select gc.getV().getBaseVariable().getDefinition().(SsaExplicitDefinition).getRhs(), "test"
//where s.getAnElement().toString().matches("%https://foo.com%")
//where a.getBase() = b.getBase()
//select a.getBase(), b.getBase()