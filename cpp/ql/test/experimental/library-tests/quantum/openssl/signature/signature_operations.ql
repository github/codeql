import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.Operations.EVPSignatureOperation


from EVP_Signature_Operation n
select n, n.(Call).getTarget().getName(), n.getOutputArg()