/**
 * @name FTP-related functions are being called.
 * @description FTP is considered insecure. Use SSH/SFTP/SCP or some other encrypted protocol.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b321-ftplib
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/ftp-use
 */

import python

from AssignStmt a
where a.getValue().toString() = "FTP()"
  and exists(a.getLocation().getFile().getRelativePath())
select a, "FTP-related functions are being called. FTP is considered insecure. Use SSH/SFTP/SCP or some other encrypted protocol."