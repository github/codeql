/**
 * @name CSRF protection not enabled
 * @description Not enabling CSRF protection may make the application
 *              vulnerable to a Cross-Site Request Forgery (CSRF) attack.
 * @kind problem
 * @problem.severity warning
 * @security-severity 8.8
 * @precision high
 * @id rb/csrf-protection-not-enabled
 * @tags security
 *       external/cwe/cwe-352
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.frameworks.ActionController

from ActionController::RootController c
where
  not exists(ActionController::ProtectFromForgeryCall call |
    c.getSelf().flowsTo(call.getReceiver())
  )
select c, "Potential CSRF vulnerability due to forgery protection not being enabled"
