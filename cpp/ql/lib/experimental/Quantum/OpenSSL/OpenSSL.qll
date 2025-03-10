import cpp
import semmle.code.cpp.dataflow.new.DataFlow

module OpenSSLModel {
  import experimental.Quantum.Language
  import experimental.Quantum.OpenSSL.EVPCipherOperation
  import experimental.Quantum.OpenSSL.EVPHashOperation
  import experimental.Quantum.OpenSSL.EVPCipherAlgorithmSource
  import experimental.Quantum.OpenSSL.EVPHashAlgorithmSource
  import experimental.Quantum.OpenSSL.Random
  // Imports the additional algorithm flow step for OpenSSL
  import experimental.Quantum.OpenSSL.OpenSSLAlgorithmGetter


//   // TODO: trace CTX from init variants to the context arg of EVP update calls
// //https://docs.openssl.org/master/man3/EVP_EncryptInit/#synopsis
//   abstract class EVP_Cipher_Init_Call extends Call {
//     Expr getContextArg() { result = this.getArgument(0) }
//     abstract Expr getKeyArg();

//     abstract Expr getIVArg();

//     abstract Crypto::CipherOperationSubtype getCipherOperationSubtype();
//   }

//   abstract class EVP_Cipher_EX_Init_Call extends EVP_Cipher_Init_Call {
//     override Expr getKeyArg() { result = this.getArgument(3) }

//     override Expr getIVArg() { result = this.getArgument(4) }
//   }

//   abstract class EVP_Cipher_EX2_Init_Call extends EVP_Cipher_Init_Call {
//     override Expr getKeyArg() { result = this.getArgument(2) }

//     override Expr getIVArg() { result = this.getArgument(3) }
//   }

//   abstract class EVP_Cipher_Operation_Call extends Crypto::CipherOperationInstance instanceof Call {
//     Expr getContextArg() { result = this.(Call).getArgument(0) }
//     abstract Expr getInputArg();
//     Expr getOutputArg() { result = this.(Call).getArgument(1) }
//     abstract Expr getInitCall();
//   }

//   abstract class EVP_Update_Call extends EVP_Cipher_Operation_Call {
//     override Expr getInputArg() { result = this.(Call).getArgument(3) }

//   }

//   abstract class EVP_Final_Call extends EVP_Cipher_Operation_Call{
//     override Expr getInputArg() { none() }

//   }

//   class EVP_Cipher_Call extends EVP_Cipher_Operation_Call{
//     // TODO/QUESTION: what is the better way to do this?
//     EVP_Cipher_Call() { this.(Call).getTarget().getName() = "EVP_Cipher" }

//     override Expr getInputArg() { result = this.(Call).getArgument(2) }

//     override Expr getOutputArg() { result = this.(Call).getArgument(1) }

//     override Crypto::CipherOperationSubtype getCipherOperationSubtype(){
//       result instanceof Crypto::EncryptionSubtype
//     }

//     override Expr getInitCall(){
//       //TODO:
//       none()
//     }

//     override Crypto::NonceArtifactConsumer getNonceConsumer(){
//       none()
//     }

//     override Crypto::CipherInputConsumer getInputConsumer(){
//       none()
//     }

//     override Crypto::CipherOutputArtifactInstance getOutputArtifact(){
//       none()
//     }

//     override Crypto::AlgorithmConsumer getAlgorithmConsumer(){
//       none()
//     }
//   }


  //TODO: what about EVP_CIpher


  // class EVP_EncryptUpdateCall extends Crypto::CipherOperationInstance instanceof Call {
  //   // NICK QUESTION: is there a better way to tie this to openssl?
  //   EVP_EncryptUpdateCall() { this.getTarget().getName() = "EVP_EncryptUpdate" }

  //   Expr getContextArg() { result = super.getArgument(0) }

  //   Expr getInputArg() { result = super.getArgument(3) }

  //   Expr getOutputArg() { result = super.getArgument(1) }

  //   override Crypto::CipherOperationSubtype getCipherOperationSubtype(){
  //     result instanceof Crypto::EncryptionSubtype
  //   }

  //   override Crypto::NonceArtifactConsumer getNonceConsumer(){
  //     none()
  //   }

  //   override Crypto::CipherInputConsumer getInputConsumer(){
  //     none()
  //   }

  //   override Crypto::CipherOutputArtifactInstance getOutputArtifact(){
  //     none()
  //   }

  //   override Crypto::AlgorithmConsumer getAlgorithmConsumer(){
  //     none()
  //   }

  // }

  //EVP_EncryptUpdate

  // /**
  //  * Hash function references in OpenSSL.
  //  */
  // predicate hash_ref_type_mapping_known(string name, Crypto::THashType algo) {
  //   // `ma` name has an LN_ or SN_ prefix, which we want to ignore
  //   // capture any name after the _ prefix using regex matching
  //   name = ["sha1", "sha160"] and algo instanceof Crypto::SHA1
  //   or
  //   name = ["sha224", "sha256", "sha384", "sha512"] and algo instanceof Crypto::SHA2
  //   or
  //   name = ["sha3-224", "sha3-256", "sha3-384", "sha3-512"] and algo instanceof Crypto::SHA3
  //   or
  //   name = "md2" and algo instanceof Crypto::MD2
  //   or
  //   name = "md4" and algo instanceof Crypto::MD4
  //   or
  //   name = "md5" and algo instanceof Crypto::MD5
  //   or
  //   name = "ripemd160" and algo instanceof Crypto::RIPEMD160
  //   or
  //   name = "whirlpool" and algo instanceof Crypto::WHIRLPOOL
  // }

  // predicate hash_ref_type_mapping(FunctionCallOrMacroAccess ref, string name, Crypto::THashType algo) {
  //   name = ref.getTargetName().regexpCapture("(?:SN_|LN_|EVP_)([a-z0-9]+)", 1) and
  //   hash_ref_type_mapping_known(name, algo)
  // }

  // class FunctionCallOrMacroAccess extends Element {
  //   FunctionCallOrMacroAccess() { this instanceof FunctionCall or this instanceof MacroAccess }

  //   string getTargetName() {
  //     result = this.(FunctionCall).getTarget().getName()
  //     or
  //     result = this.(MacroAccess).getMacroName()
  //   }
  // }

  // class HashAlgorithmCallOrMacro extends Crypto::HashAlgorithmInstance instanceof FunctionCallOrMacroAccess
  // {
  //   HashAlgorithmCallOrMacro() { hash_ref_type_mapping(this, _, _) }

  //   string getTargetName() { result = this.(FunctionCallOrMacroAccess).getTargetName() }
  // }

  // class HashAlgorithm extends Crypto::HashAlgorithm {
  //   HashAlgorithmCallOrMacro instance;

  //   HashAlgorithm() { this = Crypto::THashAlgorithm(instance) }

  //   override string getSHA2OrSHA3DigestSize(Location location) {
  //     (
  //       this.getHashType() instanceof Crypto::SHA2 or
  //       this.getHashType() instanceof Crypto::SHA3
  //     ) and
  //     exists(string name |
  //       hash_ref_type_mapping(instance, name, this.getHashType()) and
  //       result = name.regexpFind("\\d{3}", 0, _) and
  //       location = instance.getLocation()
  //     )
  //   }

  //   override string getRawAlgorithmName() { result = instance.getTargetName() }

  //   override Crypto::THashType getHashType() { hash_ref_type_mapping(instance, _, result) }

  //   Element getInstance() { result = instance }

  //   override Location getLocation() { result = instance.getLocation() }
  // }

  // /**
  //  * Data-flow configuration for key derivation algorithm flow to EVP_KDF_derive.
  //  */
  // module AlgorithmToEVPKeyDeriveConfig implements DataFlow::ConfigSig {
  //   predicate isSource(DataFlow::Node source) {
  //     source.asExpr() = any(KeyDerivationAlgorithm a).getInstance()
  //   }

  //   predicate isSink(DataFlow::Node sink) {
  //     exists(EVP_KDF_derive kdo |
  //       sink.asExpr() = kdo.getCall().getAlgorithmArg()
  //       or
  //       sink.asExpr() = kdo.getCall().getContextArg() // via `EVP_KDF_CTX_set_params`
  //     )
  //   }

  //   predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  //     none() // TODO
  //   }
  // }

  // module AlgorithmToEVPKeyDeriveFlow = DataFlow::Global<AlgorithmToEVPKeyDeriveConfig>;

  // predicate algorithm_to_EVP_KDF_derive(KeyDerivationAlgorithm algo, EVP_KDF_derive derive) {
  //   none()
  // }

  // /**
  //  * Key derivation operation (e.g., `EVP_KDF_derive`)
  //  */
  // class EVP_KDF_derive_FunctionCall extends Crypto::KeyDerivationOperationInstance instanceof FunctionCall
  // {
  //   EVP_KDF_derive_FunctionCall() { this.getTarget().getName() = "EVP_KDF_derive" }

  //   Expr getAlgorithmArg() { result = super.getArgument(3) }

  //   Expr getContextArg() { result = super.getArgument(0) }
  // }

  // class EVP_KDF_derive extends Crypto::KeyDerivationOperation {
  //   EVP_KDF_derive_FunctionCall instance;

  //   EVP_KDF_derive() { this = Crypto::TKeyDerivationOperation(instance) }

  //   override Crypto::Algorithm getAlgorithm() { algorithm_to_EVP_KDF_derive(result, this) }

  //   EVP_KDF_derive_FunctionCall getCall() { result = instance }
  // }

  // /**
  //  * Key derivation algorithm nodes
  //  */
  // abstract class KeyDerivationAlgorithm extends Crypto::KeyDerivationAlgorithm {
  //   abstract Expr getInstance();
  // }

  // /**
  //  * `EVP_KDF_fetch` returns a key derivation algorithm.
  //  */
  // class EVP_KDF_fetch_Call extends FunctionCall {
  //   EVP_KDF_fetch_Call() { this.getTarget().getName() = "EVP_KDF_fetch" }

  //   Expr getAlgorithmArg() { result = this.getArgument(1) }
  // }

  // class EVP_KDF_fetch_AlgorithmArg extends Crypto::KeyDerivationAlgorithmInstance instanceof Expr {
  //   EVP_KDF_fetch_AlgorithmArg() { exists(EVP_KDF_fetch_Call call | this = call.getAlgorithmArg()) }
  // }

  // predicate kdf_names(string algo) { algo = ["HKDF", "PKCS12KDF", "PBKDF2"] }

  // class KDFAlgorithmStringLiteral extends StringLiteral {
  //   KDFAlgorithmStringLiteral() { kdf_names(this.getValue().toUpperCase()) }
  // }

  // private module AlgorithmStringToFetchConfig implements DataFlow::ConfigSig {
  //   predicate isSource(DataFlow::Node src) { src.asExpr() instanceof KDFAlgorithmStringLiteral }

  //   predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof EVP_KDF_fetch_AlgorithmArg }
  // }

  // module AlgorithmStringToFetchFlow = DataFlow::Global<AlgorithmStringToFetchConfig>;

  // predicate algorithmStringToKDFFetchArgFlow(
  //   string name, KDFAlgorithmStringLiteral origin, EVP_KDF_fetch_AlgorithmArg arg
  // ) {
  //   origin.getValue().toUpperCase() = name and
  //   AlgorithmStringToFetchFlow::flow(DataFlow::exprNode(origin), DataFlow::exprNode(arg))
  // }

  // /**
  //  * HKDF key derivation algorithm.
  //  */
  // class HKDF extends KeyDerivationAlgorithm, Crypto::HKDF {
  //   KDFAlgorithmStringLiteral origin;
  //   EVP_KDF_fetch_AlgorithmArg instance;

  //   HKDF() {
  //     this = Crypto::TKeyDerivationAlgorithm(instance) and
  //     algorithmStringToKDFFetchArgFlow("HKDF", origin, instance)
  //   }

  //   override string getRawAlgorithmName() { result = origin.getValue() }

  //   override Crypto::HashAlgorithm getHashAlgorithm() { none() }

  //   override Crypto::LocatableElement getOrigin(string name) {
  //     result = origin and name = origin.toString()
  //   }

  //   override Expr getInstance() { result = origin }
  // }

  // /**
  //  * PBKDF2 key derivation algorithm.
  //  */
  // class PBKDF2 extends KeyDerivationAlgorithm, Crypto::PBKDF2 {
  //   KDFAlgorithmStringLiteral origin;
  //   EVP_KDF_fetch_AlgorithmArg instance;

  //   PBKDF2() {
  //     this = Crypto::TKeyDerivationAlgorithm(instance) and
  //     algorithmStringToKDFFetchArgFlow("PBKDF2", origin, instance)
  //   }

  //   override string getRawAlgorithmName() { result = origin.getValue() }

  //   override string getIterationCount(Location location) { none() } // TODO

  //   override string getKeyLength(Location location) { none() } // TODO

  //   override Crypto::HashAlgorithm getHashAlgorithm() { none() } // TODO

  //   override Crypto::LocatableElement getOrigin(string name) {
  //     result = origin and name = origin.toString()
  //   }

  //   override Expr getInstance() { result = instance }
  // }

  // /**
  //  * PKCS12KDF key derivation algorithm.
  //  */
  // class PKCS12KDF extends KeyDerivationAlgorithm, Crypto::PKCS12KDF {
  //   KDFAlgorithmStringLiteral origin;
  //   EVP_KDF_fetch_AlgorithmArg instance;

  //   PKCS12KDF() {
  //     this = Crypto::TKeyDerivationAlgorithm(instance) and
  //     algorithmStringToKDFFetchArgFlow("PKCS12KDF", origin, instance)
  //   }

  //   override string getRawAlgorithmName() { result = origin.getValue() }

  //   override string getIterationCount(Location location) { none() } // TODO

  //   override string getIDByte(Location location) { none() } // TODO

  //   override Crypto::HashAlgorithm getHashAlgorithm() { none() } // TODO

  //   override Crypto::LocatableElement getOrigin(string name) {
  //     result = origin and name = origin.toString()
  //   }

  //   override Expr getInstance() { result = instance }
  // }
}
