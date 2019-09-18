import python
import semmle.python.security.TaintTracking

private import semmle.python.security.SensitiveData
private import semmle.crypto.Crypto as CryptoLib


abstract class WeakCryptoSink extends TaintSink {

    override predicate sinks(TaintKind taint) {
        taint instanceof SensitiveData
    }
}

module Pycrypto {

    ModuleObject cipher(string name) {
        exists(PackageObject crypto |
            crypto.getName() = "Crypto.Cipher" |
            crypto.submodule(name) = result
        )
    }

    class CipherInstance extends TaintKind {

        string name;

        CipherInstance() {
            this = "Crypto.Cipher." + name  and
            exists(cipher(name))
        }

        string getName() {
            result = name
        }

        CryptoLib::CryptographicAlgorithm getAlgorithm() {
            result.getName() = name
        }

        predicate isWeak() {
            this.getAlgorithm().isWeak()
        }

    }

    class CipherInstanceSource extends TaintSource {

        CipherInstance instance;

        CipherInstanceSource() {
            exists(AttrNode attr |
                this.(CallNode).getFunction() = attr and
                attr.getObject("new").refersTo(cipher(instance.getName()))
            )
        }

        override string toString() {
            result = "Source of " + instance
        }

        override predicate isSourceOf(TaintKind kind) { 
            kind = instance
        }

    }

    class PycryptoWeakCryptoSink extends WeakCryptoSink {

        string name;

        PycryptoWeakCryptoSink() {
            exists(CallNode call, AttrNode method, CipherInstance Cipher |
                call.getAnArg() = this and
                call.getFunction() = method and
                Cipher.taints(method.getObject("encrypt")) and
                Cipher.isWeak() and
                Cipher.getName() = name
            )
        }

        override string toString() {
            result = "Use of weak crypto algorithm " + name
        }

    }

}

module Cryptography {

    PackageObject ciphers() {
        result.getName() = "cryptography.hazmat.primitives.ciphers"
    }

    class CipherClass extends ClassObject {
        CipherClass() {
            ciphers().attr("Cipher") = this
        }

    }

    class AlgorithmClass extends ClassObject {

        AlgorithmClass()  {
            ciphers().submodule("algorithms").attr(_) = this
        }

        string getAlgorithmName() {
            result = this.declaredAttribute("name").(StringObject).getText()
        }

        predicate isWeak() {
            exists(CryptoLib::CryptographicAlgorithm algo |
                algo.getName() = this.getAlgorithmName() and
                algo.isWeak()
            )
        }
    }

    class CipherInstance extends TaintKind {

        AlgorithmClass cls;

        CipherInstance() {
            this = "cryptography.Cipher." + cls.getAlgorithmName()
        }

        AlgorithmClass getAlgorithm() {
            result = cls
        }

        predicate isWeak() {
            cls.isWeak()
        }

        override TaintKind getTaintOfMethodResult(string name) { 
            name = "encryptor" and
            result.(Encryptor).getAlgorithm() = this.getAlgorithm()
        }

    }

    class CipherSource extends TaintSource {

        CipherSource() {
            this.(CallNode).getFunction().refersTo(any(CipherClass cls))
        }

        override predicate isSourceOf(TaintKind kind) {
            this.(CallNode).getArg(0).refersTo(_, kind.(CipherInstance).getAlgorithm(), _)
        }

        override string toString() {
            result = "cryptography.Cipher.source"
        }

    }

    class Encryptor extends TaintKind {

        AlgorithmClass cls;

        Encryptor() {
            this = "cryptography.encryptor." + cls.getAlgorithmName()

        }

        AlgorithmClass getAlgorithm() {
            result = cls
        }

    }

    class CryptographyWeakCryptoSink extends WeakCryptoSink {

        CryptographyWeakCryptoSink() {
            exists(CallNode call, AttrNode method, Encryptor encryptor |
                call.getAnArg() = this and
                call.getFunction() = method and
                encryptor.taints(method.getObject("update")) and
                encryptor.getAlgorithm().isWeak()
            )
        }

        override string toString() {
            result = "Use of weak crypto algorithm"
        }

    }


}

private class CipherConfig extends TaintTracking::Configuration {

    CipherConfig() { this = "Crypto cipher config" }

    override predicate isSource(TaintTracking::Source source) {
        source instanceof Pycrypto::CipherInstanceSource
        or
        source instanceof Cryptography::CipherSource
    }

}


