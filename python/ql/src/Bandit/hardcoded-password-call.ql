/**
 * @name Possible hardcoded password.
 * @description Possible hardcoded password
 * 		https://bandit.readthedocs.io/en/latest/plugins/b105_hardcoded_password_string.html
 * @kind problem
 * @tags security
 * @problem.severity recommendation
 * @precision medium
 * @id py/bandit/password-call
 */

import python


from Call c
where exists(Keyword k | k = c.getANamedArg() and k.getArg() = "password")    
select c, "Possible hardcoded password."