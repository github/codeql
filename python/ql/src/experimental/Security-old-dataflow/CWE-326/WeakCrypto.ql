/**
 * @name Use of weak cryptographic key
 * @description Use of a cryptographic key that is too small may allow the encryption to be broken.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id py/weak-crypto-key
 * @tags security
 *       external/cwe/cwe-326
 */

import python

int minimumSecureKeySize(string algo) {
  algo = "DSA" and result = 2048
  or
  algo = "RSA" and result = 2048
  or
  algo = "ECC" and result = 224
}

predicate dsaRsaKeySizeArg(FunctionValue func, string algorithm, string arg) {
  exists(ModuleValue mod | func = mod.attr(_) |
    algorithm = "DSA" and
    (
      mod = Module::named("cryptography.hazmat.primitives.asymmetric.dsa") and arg = "key_size"
      or
      mod = Module::named("Crypto.PublicKey.DSA") and arg = "bits"
      or
      mod = Module::named("Cryptodome.PublicKey.DSA") and arg = "bits"
    )
    or
    algorithm = "RSA" and
    (
      mod = Module::named("cryptography.hazmat.primitives.asymmetric.rsa") and arg = "key_size"
      or
      mod = Module::named("Crypto.PublicKey.RSA") and arg = "bits"
      or
      mod = Module::named("Cryptodome.PublicKey.RSA") and arg = "bits"
    )
  )
}

predicate ecKeySizeArg(FunctionValue func, string arg) {
  exists(ModuleValue mod | func = mod.attr(_) |
    mod = Module::named("cryptography.hazmat.primitives.asymmetric.ec") and arg = "curve"
  )
}

int keySizeFromCurve(ClassValue curveClass) {
  result = curveClass.declaredAttribute("key_size").(NumericValue).getIntValue()
}

predicate algorithmAndKeysizeForCall(
  CallNode call, string algorithm, int keySize, ControlFlowNode keyOrigin
) {
  exists(FunctionValue func, string argname, ControlFlowNode arg |
    arg = func.getNamedArgumentForCall(call, argname)
  |
    exists(NumericValue key |
      arg.pointsTo(key, keyOrigin) and
      dsaRsaKeySizeArg(func, algorithm, argname) and
      keySize = key.getIntValue()
    )
    or
    exists(Value curveClassInstance |
      algorithm = "ECC" and
      ecKeySizeArg(func, argname) and
      arg.pointsTo(_, curveClassInstance, keyOrigin) and
      keySize = keySizeFromCurve(curveClassInstance.getClass())
    )
  )
}

from CallNode call, string algo, int keySize, ControlFlowNode origin
where
  algorithmAndKeysizeForCall(call, algo, keySize, origin) and
  keySize < minimumSecureKeySize(algo)
select call,
  "Creation of an " + algo + " key uses $@ bits, which is below " + minimumSecureKeySize(algo) +
    " and considered breakable.", origin, keySize.toString()
