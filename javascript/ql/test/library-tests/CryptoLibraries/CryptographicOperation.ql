import javascript

string getBlockMode(CryptographicOperation operation) {
  if
    operation.getAlgorithm() instanceof EncryptionAlgorithm and
    not operation.getAlgorithm().(EncryptionAlgorithm).isStreamCipher()
  then
    if exists(operation.getBlockMode())
    then result = operation.getBlockMode()
    else result = "<unknown>"
  else result = "<none>"
}

from CryptographicOperation operation
select operation, operation.getAlgorithm().getName(), operation.getAnInput(),
  getBlockMode(operation)
