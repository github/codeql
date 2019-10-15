/**
 * @name A telent or FTP-related module is being imported.
 * @description Telent and FTP is considered insecure. Use SSH/SFTP/SCP or some other encrypted protocol.
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b402-import-ftplib
 *         https://bandit.readthedocs.io/en/latest/blacklists/blacklist_calls.html#b312-telnetlib
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/ftp-import
 */

import python

from Import i
where i.getAnImportedModuleName() = "ftplib.FTP"
   or i.getAnImportedModuleName() = "telnetlib"
select i, "A telnet or FTP related module is being imported. Telnet is considered insecure. Use SSH or some other encrypted protocol."