/**
 * @name Use of insecure cipher mode
 * @description Use of insecure cipher mode cryptography.hazmat.primitives.ciphers.modes.ECB.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b304-b305-ciphers-and-modes
 * @kind problem
 * @tags reliability
 *       security
 * @problem.severity warning
 * @precision high
 * @id py/bandit/cipher-modes
 */

import python

from Expr e
where e.(Call).getFunc().toString() = "ECB" 
select e, "Use of insecure cipher mode cryptography.hazmat.primitives.ciphers.modes.ECB."