import cpp
import experimental.quantum.Language
import experimental.quantum.OpenSSL.AlgorithmInstances.SignatureAlgorithmInstance

from KnownOpenSSLSignatureConstantAlgorithmInstance algoInstance
select algoInstance, algoInstance.getAlgorithmType(), algoInstance.getAVC()
