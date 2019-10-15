/**
 * @name Telnet-related functions are being called.
 * @description Telnet is considered insecure. Use SSH/SFTP/SCP or some other encrypted protocol.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b312-telnetlib
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision medium
 * @id py/bandit/telent
 */

import python

from Attribute a
where a.getObject().toString() = "telnetlib"
select a, "Telnet-related functions are being called. Telnet is considered insecure. Use SSH or some other encrypted protocol."