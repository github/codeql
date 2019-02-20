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

predicate dsaRsaKeySizeArg(FunctionObject obj, string algorithm, string arg) {
    exists(ModuleObject mod |
        mod.attr(_) = obj |
        algorithm = "DSA" and
        (
            mod.getName() = "cryptography.hazmat.primitives.asymmetric.dsa" and arg = "key_size"
            or
            mod.getName() = "Crypto.PublicKey.DSA" and arg = "bits"
            or
            mod.getName() = "Cryptodome.PublicKey.DSA" and arg = "bits"
        )
        or
        algorithm = "RSA" and
        (
            mod.getName() = "cryptography.hazmat.primitives.asymmetric.rsa" and arg = "key_size"
            or
            mod.getName() = "Crypto.PublicKey.RSA" and arg = "bits"
            or
            mod.getName() = "Cryptodome.PublicKey.RSA" and arg = "bits"
        )
    )
}

predicate ecKeySizeArg(FunctionObject obj, string arg) {
    exists(ModuleObject mod |
        mod.attr(_) = obj |
        mod.getName() = "cryptography.hazmat.primitives.asymmetric.ec" and arg = "curve"
    )
}

int keySizeFromCurve(ClassObject curveClass) {
    result = curveClass.declaredAttribute("key_size").(NumericObject).intValue()
}

predicate algorithmAndKeysizeForCall(CallNode call, string algorithm, int keySize, ControlFlowNode keyOrigin) {
    exists(FunctionObject func, string argname, ControlFlowNode arg |
        arg = func.getNamedArgumentForCall(call, argname) |
        exists(NumericObject key |
            arg.refersTo(key, keyOrigin) and
            dsaRsaKeySizeArg(func, algorithm, argname) and
            keySize = key.intValue()
        )
        or
        exists(ClassObject curve |
            arg.refersTo(_, curve, keyOrigin) and
            ecKeySizeArg(func, argname) and
            algorithm = "ECC" and
            keySize = keySizeFromCurve(curve)
        )
    )
}


from CallNode call, ControlFlowNode origin, string algo, int keySize
where
    algorithmAndKeysizeForCall(call, algo, keySize, origin) and
    keySize < minimumSecureKeySize(algo)
select call, "Creation of an " + algo + " key uses $@ bits, which is below " + minimumSecureKeySize(algo) + " and considered breakable.", origin, keySize.toString()


