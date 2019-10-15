/**
 * @name Library and its module ARC2 and ARC4 are no longer actively maintained
 * @description The pyCrypto library and its module ARC2,ARC4,Blowfish,DES,XOR,SHA,Random,Counter are no longer actively maintained 
		and have been deprecated. Consider using pyca/cryptography library.
 * 		https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b413-import-pycrypto
 * @kind problem
 * @tags security
 * @problem.severity error
 * @precision high
 * @id py/bandit/ciphers
 */

import python

from ImportMember i
where	i.getImportedModuleName() = "Crypto.Cipher.ARC2" 
or 		i.getImportedModuleName() = "Crypto.Cipher.ARC4" 
or 		i.getImportedModuleName() = "Crypto.Cipher.Blowfish" 
or 		i.getImportedModuleName() = "Crypto.Cipher.DES" 
or 		i.getImportedModuleName() = "Crypto.Cipher.XOR" 
or 		i.getImportedModuleName() = "Crypto.Cipher.AES"
or 		i.getImportedModuleName() = "Crypto.Hash.SHA"
or 		i.getImportedModuleName() = "Crypto.Hash.MD2"
or 		i.getImportedModuleName() = "Crypto.Hash.MD4"
or 		i.getImportedModuleName() = "Crypto.Hash.MD5"
or 		i.getImportedModuleName() = "Crypto.Random"
or 		i.getImportedModuleName() = "Crypto.Util.Counter"
select i, "The pyCrypto library and its module ARC2,ARC4,Blowfish,DES,XOR,SHA,MD2,MD4,MD5,Random,Counter are no longer actively maintained and have been deprecated. Consider using pyca/cryptography library."


