/**
 * @name Dangerous http.server module
 * @description Use of a module that is not recommended for production, as it only implements basic security checks.
 * @kind problem
 * @problem.severity warning
 * @id py/dangerous-http-server
 * @tags reliability
 *       security
 */

import python

ModuleValue http_server(string mod, string msg) {
  mod = "http.server" and
  msg = "http.server is not recommended for production. It only implements basic security checks." and
  result = Module::named(mod)
}

from AstNode c, string mod, string msg
where c = http_server(mod, msg).getAReference().getNode()
select c, msg
