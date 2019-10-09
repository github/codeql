/**
 * Provides classes for working with symmetric cryptography algorithms.
 */
import csharp
private import  semmle.code.csharp.Common

/**
 * The class `System.Security.Cryptography.SymmetricAlgorithm` or any sub class of this class.
 */
class SymmetricAlgorithm extends Class {
  SymmetricAlgorithm() {
    this.getABaseType*().hasQualifiedName("System.Security.Cryptography", "SymmetricAlgorithm")
  }

  /** Gets the `IV` property. */
  Property getIVProperty() {
    result = this.getProperty("IV")
  }

  /** Gets the 'Key' property. */
  Property getKeyProperty() {
    result = this.getProperty("Key")
  }
  
  /** Gets a method call that constructs a symmetric encryptor using variable `v`. */
  MethodCall getASymmetricEncryptor(Variable v) {
    result.getTarget() = any(Method m |
      m = getAMethod("CreateEncryptor")) 
    and result.getQualifier() = v.getAnAccess()
  }
  
  /** Gets a method call that constructs a symmetric decryptor using variable `v`. */
  MethodCall getASymmetricDecryptor(Variable v) {
    result.getTarget() = any(Method m |
      m = getAMethod("CreateDecryptor")) 
    and result.getQualifier() = v.getAnAccess()
  }
}

/**
 * Holds if the expression 'e' creates DES symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingDES (Expr e) {
    isCreatingObject(e, "System.Security.Cryptography.DES") 
 or isReturningObject(e, "System.Security.Cryptography.DES") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "DES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.DES") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "DES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.DES")
}

/**
 * Holds if the expression 'e' creates Triple DES symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingTripleDES (Expr e) {
    isCreatingObject(e, "System.Security.Cryptography.TripleDES") 
 or isReturningObject(e, "System.Security.Cryptography.TripleDES") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "TripleDES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "3DES") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "Triple DES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.TripleDES") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "TripleDES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "3DES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "Triple DES")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.TripleDES")
}

/**
 * Holds if the expression 'e' creates RC2 symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingRC2 (Expr e) {
    isCreatingObject(e, "System.Security.Cryptography.RC2") 
 or isReturningObject(e, "System.Security.Cryptography.RC2") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "RC2")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.RC2") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "RC2")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.RC2")
}

/**
 * Holds if the expression 'e' creates Rijndael symmetric algorithm. 
 */
 
 predicate isCreatingRijndael (Expr e) {
    isCreatingObject(e, "System.Security.Cryptography.Rijndael") 
 or isReturningObject(e, "System.Security.Cryptography.Rijndael") 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "Rijndael")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "RijndaelManaged")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.Rijndael")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.RijndaelManaged")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "System.Security.Cryptography.SymmetricAlgorithm") // this creates Rijndael 
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "Rijndael")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.Rijndael")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "RijndaelManaged")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.RijndaelManaged")
 or isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig","CreateFromName", 0, "System.Security.Cryptography.SymmetricAlgorithm") // this creates Rijndael
}
 