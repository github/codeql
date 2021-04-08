import python
import semmle.python.dataflow.TaintTracking
private import semmle.python.security.SensitiveData
private import semmle.crypto.Crypto as CryptoLib

abstract class WeakCryptoSink extends TaintSink {
  override predicate sinks(TaintKind taint) { taint instanceof SensitiveData }
}

/** Modeling the 'pycrypto' package https://github.com/dlitz/pycrypto (latest release 2013) */
module Pycrypto {
  ModuleValue cipher(string name) { result = Module::named("Crypto.Cipher").attr(name) }

  class CipherInstance extends TaintKind {
    string name;

    CipherInstance() {
      this = "Crypto.Cipher." + name and
      exists(cipher(name))
    }

    string getName() { result = name }

    CryptoLib::CryptographicAlgorithm getAlgorithm() { result.getName() = name }

    predicate isWeak() { this.getAlgorithm().isWeak() }
  }

  class CipherInstanceSource extends TaintSource {
    CipherInstance instance;

    CipherInstanceSource() {
      exists(AttrNode attr |
        this.(CallNode).getFunction() = attr and
        attr.getObject("new").pointsTo(cipher(instance.getName()))
      )
    }

    override string toString() { result = "Source of " + instance }

    override predicate isSourceOf(TaintKind kind) { kind = instance }
  }

  class PycryptoWeakCryptoSink extends WeakCryptoSink {
    string name;

    PycryptoWeakCryptoSink() {
      exists(CallNode call, AttrNode method, CipherInstance cipher |
        call.getAnArg() = this and
        call.getFunction() = method and
        cipher.taints(method.getObject("encrypt")) and
        cipher.isWeak() and
        cipher.getName() = name
      )
    }

    override string toString() { result = "Use of weak crypto algorithm " + name }
  }
}

module Cryptography {
  ModuleValue ciphers() {
    result = Module::named("cryptography.hazmat.primitives.ciphers") and
    result.isPackage()
  }

  class CipherClass extends ClassValue {
    CipherClass() { ciphers().attr("Cipher") = this }
  }

  class AlgorithmClass extends ClassValue {
    AlgorithmClass() { ciphers().attr("algorithms").attr(_) = this }

    string getAlgorithmName() { result = this.declaredAttribute("name").(StringValue).getText() }

    predicate isWeak() {
      exists(CryptoLib::CryptographicAlgorithm algo |
        algo.getName() = this.getAlgorithmName() and
        algo.isWeak()
      )
    }
  }

  class CipherInstance extends TaintKind {
    AlgorithmClass cls;

    CipherInstance() { this = "cryptography.Cipher." + cls.getAlgorithmName() }

    AlgorithmClass getAlgorithm() { result = cls }

    predicate isWeak() { cls.isWeak() }

    override TaintKind getTaintOfMethodResult(string name) {
      name = "encryptor" and
      result.(Encryptor).getAlgorithm() = this.getAlgorithm()
    }
  }

  class CipherSource extends TaintSource {
    CipherSource() { this.(CallNode).getFunction().pointsTo(any(CipherClass cls)) }

    override predicate isSourceOf(TaintKind kind) {
      this.(CallNode).getArg(0).pointsTo().getClass() = kind.(CipherInstance).getAlgorithm()
    }

    override string toString() { result = "cryptography.Cipher.source" }
  }

  class Encryptor extends TaintKind {
    AlgorithmClass cls;

    Encryptor() { this = "cryptography.encryptor." + cls.getAlgorithmName() }

    AlgorithmClass getAlgorithm() { result = cls }
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

    override string toString() { result = "Use of weak crypto algorithm" }
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
