/**
 * Provides classes for working with symmetric cryptography algorithms.
 */

import csharp

/**
 * Holds if the object creation `oc` is the creation of the reference type with the specified `qualifiedName`, or a class derived from
 * the class with the specified `qualifiedName`.
 */
private predicate isCreatingObject(ObjectCreation oc, string qualifiedName) {
  exists(RefType t | t = oc.getType() | t.getBaseClass*().hasQualifiedName(qualifiedName))
}

/**
 * Holds if the method call `mc` is returning the reference type with the specified `qualifiedName`.
 * and the target of the method call is a library method.
 */
private predicate isReturningObject(MethodCall mc, string qualifiedName) {
  mc.getTarget().fromLibrary() and
  exists(RefType t | t = mc.getType() | t.hasQualifiedName(qualifiedName))
}

/**
 * Holds if the method call `mc` is a call on the library method target with the specified `qualifiedName` and `methodName`, and an argument at
 * index `argumentIndex` has the specified value `argumentValue` (case-insensitive).
 */
bindingset[argumentValue]
private predicate isMethodCalledWithArg(
  MethodCall mc, string qualifiedName, string methodName, int argumentIndex, string argumentValue
) {
  mc.getTarget().fromLibrary() and
  mc.getTarget().hasQualifiedName(qualifiedName, methodName) and
  mc.getArgument(argumentIndex).getValue().toUpperCase() = argumentValue.toUpperCase()
}

/**
 * The class `System.Security.Cryptography.SymmetricAlgorithm` or any sub class of this class.
 */
class SymmetricAlgorithm extends Class {
  SymmetricAlgorithm() {
    this.getABaseType*().hasQualifiedName("System.Security.Cryptography", "SymmetricAlgorithm")
  }

  /** Gets the `IV` property. */
  Property getIVProperty() { result = this.getProperty("IV") }

  /** Gets the 'Key' property. */
  Property getKeyProperty() { result = this.getProperty("Key") }

  /** Gets a method call that constructs a symmetric encryptor. */
  MethodCall getASymmetricEncryptor() { result.getTarget() = this.getAMethod("CreateEncryptor") }

  /** Gets a method call that constructs a symmetric decryptor. */
  MethodCall getASymmetricDecryptor() { result.getTarget() = this.getAMethod("CreateDecryptor") }
}

/**
 * Holds if the expression 'e' creates DES symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingDES(Expr e) {
  isCreatingObject(e, "System.Security.Cryptography.DES") or
  isReturningObject(e, "System.Security.Cryptography.DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0, "DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.DES")
}

/**
 * Holds if the expression 'e' creates Triple DES symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingTripleDES(Expr e) {
  isCreatingObject(e, "System.Security.Cryptography.TripleDES") or
  isReturningObject(e, "System.Security.Cryptography.TripleDES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "TripleDES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "3DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "Triple DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.TripleDES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "TripleDES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0, "3DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "Triple DES") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.TripleDES")
}

/**
 * Holds if the expression 'e' creates RC2 symmetric algorithm.
 * Note: not all of the class names are supported on all platforms.
 */
predicate isCreatingRC2(Expr e) {
  isCreatingObject(e, "System.Security.Cryptography.RC2") or
  isReturningObject(e, "System.Security.Cryptography.RC2") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0, "RC2") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.RC2") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0, "RC2") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.RC2")
}

/**
 * Holds if the expression 'e' creates Rijndael symmetric algorithm.
 */
predicate isCreatingRijndael(Expr e) {
  isCreatingObject(e, "System.Security.Cryptography.Rijndael") or
  isReturningObject(e, "System.Security.Cryptography.Rijndael") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "Rijndael") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "RijndaelManaged") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.Rijndael") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.RijndaelManaged") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.SymmetricAlgorithm", "Create", 0,
    "System.Security.Cryptography.SymmetricAlgorithm") or // this creates Rijndael
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "Rijndael") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.Rijndael") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "RijndaelManaged") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.RijndaelManaged") or
  isMethodCalledWithArg(e, "System.Security.Cryptography.CryptoConfig", "CreateFromName", 0,
    "System.Security.Cryptography.SymmetricAlgorithm") // this creates Rijndael
}
