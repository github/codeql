import javascript
import semmle.javascript.frameworks.CryptoLibraries

from CryptographicOperation operation
select operation, operation.getAlgorithm().getName(), operation.getInput()
