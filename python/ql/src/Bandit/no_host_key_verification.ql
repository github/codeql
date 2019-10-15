/**
 * @name Automatically trust the unknown host key.
 * @description Paramiko call with policy set to automatically trust the unknown host key.
 * 		https://bandit.readthedocs.io/en/latest/plugins/b507_ssh_no_host_key_verification.html
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @id py/bandit/no-host-key-verification
 */

import python

predicate isAttributeOfObject(Attribute a, string objectName, string methodName) {
  a.getObject().toString() = objectName
  and a.getName() = methodName
}

from  Attribute a
where  isAttributeOfObject(a, "client", "AutoAddPolicy")
  or isAttributeOfObject(a, "client", "WarningPolicy")
select a, "Paramiko call with policy set to automatically trust the unknown host key."