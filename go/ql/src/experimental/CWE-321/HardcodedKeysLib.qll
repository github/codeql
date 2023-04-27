/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * JWT token signing vulnerabilities as well as extension points
 * for adding your own.
 */

import go
import StringOps
import DataFlow::PathGraph

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * JWT token signing vulnerabilities as well as extension points
 * for adding your own.
 */
module HardcodedKeys {
  /**
   * A data flow source for JWT token signing vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for JWT token signing vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for JWT token signing vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  private predicate isTestCode(Expr e) {
    e.getFile().getAbsolutePath().toLowerCase().matches("%test%") and
    not e.getFile().getAbsolutePath().toLowerCase().matches("%ql/test%")
  }

  private predicate isDemoCode(Expr e) {
    e.getFile().getAbsolutePath().toLowerCase().matches(["%mock%", "%demo%", "%example%"])
  }

  /**
   * A hardcoded string literal as a source for JWT token signing vulnerabilities.
   */
  private class HardcodedStringSource extends Source {
    HardcodedStringSource() {
      this.asExpr() instanceof StringLit and
      not (isTestCode(this.asExpr()) or isDemoCode(this.asExpr()))
    }
  }

  /**
   * An expression used to sign JWT tokens as a sink for JWT token signing vulnerabilities.
   */
  private class GolangJwtSign extends Sink {
    GolangJwtSign() {
      exists(string pkg |
        pkg =
          [
            "github.com/golang-jwt/jwt/v4", "github.com/dgrijalva/jwt-go",
            "github.com/form3tech-oss/jwt-go", "github.com/ory/fosite/token/jwt"
          ]
      |
        exists(DataFlow::MethodCallNode m |
          // Models the `SignedString` method
          // `func (t *Token) SignedString(key interface{}) (string, error)`
          m.getTarget().hasQualifiedName(pkg, "Token", "SignedString") and
          this = m.getArgument(0)
          or
          // Model the `Sign` method of the `SigningMethod` interface
          // type SigningMethod interface {
          //   Verify(signingString, signature string, key interface{}) error
          //   Sign(signingString string, key interface{}) (string, error)
          //   Alg() string
          // }
          m.getTarget().hasQualifiedName(pkg, "SigningMethod", "Sign") and
          this = m.getArgument(1)
        )
      )
    }
  }

  private class KatarasJwt extends Sink {
    KatarasJwt() {
      exists(string pkg |
        pkg = package("github.com/kataras/jwt", "") and
        (
          exists(DataFlow::MethodCallNode m |
            // Model the `Register` method of the type `Keys`
            // func (keys Keys) Register(alg Alg, kid string, pubKey PublicKey, privKey PrivateKey)
            m.getTarget().hasQualifiedName(pkg, "Keys", "Register")
          |
            this = m.getArgument(3)
          )
          or
          exists(DataFlow::CallNode m, string names |
            // Model the `Sign` method of the `SigningMethod` interface
            // func Sign(alg Alg, key PrivateKey, claims interface{}, opts ...SignOption) ([]byte, error)
            // func SignEncrypted(alg Alg, key PrivateKey, encrypt InjectFunc, claims interface{}, ...) ([]byte, error)
            // func SignEncryptedWithHeader(alg Alg, key PrivateKey, encrypt InjectFunc, claims interface{}, ...) ([]byte, error)
            // func SignWithHeader(alg Alg, key PrivateKey, claims interface{}, customHeader interface{}, ...) ([]byte, error)
            m.getTarget().hasQualifiedName(pkg, names) and
            names = ["Sign", "SignEncrypted", "SignEncryptedWithHeader", "SignWithHeader"]
          |
            this = m.getArgument(1)
          )
        )
      )
    }
  }

  private class IrisJwt extends Sink {
    IrisJwt() {
      exists(string pkg |
        pkg = "github.com/kataras/iris/v12/middleware/jwt" and
        (
          exists(DataFlow::CallNode m |
            //func NewSigner(signatureAlg Alg, signatureKey interface{}, maxAge time.Duration) *Signer
            m.getTarget().hasQualifiedName(pkg, "NewSigner")
          |
            this = m.getArgument(1)
          )
          or
          exists(Field f |
            // Models the `key` field of the `Signer` type
            // https://github.com/kataras/iris/blob/dccd57263617f5ca95d7621acfadf9dd37752dd6/middleware/jwt/signer.go#L17
            f.hasQualifiedName(pkg, "Signer", "Key") and
            f.getAWrite().getRhs() = this
          )
        )
      )
    }
  }

  private class GogfJwtSign extends Sink {
    GogfJwtSign() {
      exists(Field f, string pkg |
        pkg = package("github.com/gogf/gf-jwt", "") and
        // https://github.com/gogf/gf-jwt/blob/40503f05bc0a2bcd7aeba550163112afbb5c221f/auth_jwt.go#L27
        f.hasQualifiedName(pkg, "GfJWTMiddleware", "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }

  private class GinJwtSign extends Sink {
    GinJwtSign() {
      exists(Field f |
        // https://pkg.go.dev/github.com/appleboy/gin-jwt/v2#GinJWTMiddleware
        f.hasQualifiedName("github.com/appleboy/gin-jwt/v2", "GinJWTMiddleware", "Key") and
        f.getAWrite().getRhs() = this
      )
    }
  }

  private class SquareJoseKey extends Sink {
    SquareJoseKey() {
      exists(Field f, string pkg |
        // type Recipient struct {
        // 	Algorithm  KeyAlgorithm
        // 	Key        interface{}
        // 	KeyID      string
        // 	PBES2Count int
        // 	PBES2Salt  []byte
        // }
        // type SigningKey struct {
        // 	Algorithm SignatureAlgorithm
        // 	Key       interface{}
        // }
        f.hasQualifiedName(pkg, ["Recipient", "SigningKey"], "Key") and
        f.getAWrite().getRhs() = this
      |
        pkg = ["github.com/square/go-jose/v3", "gopkg.in/square/go-jose.v2"]
      )
    }
  }

  private class CrystalHqJwtSigner extends Sink {
    CrystalHqJwtSigner() {
      exists(DataFlow::CallNode m |
        // `func NewSignerHS(alg Algorithm, key []byte) (Signer, error)`
        m.getTarget().hasQualifiedName("github.com/cristalhq/jwt/v3", "NewSignerHS")
      |
        this = m.getArgument(1)
      )
    }
  }

  private class GoKitJwt extends Sink {
    GoKitJwt() {
      exists(DataFlow::CallNode m |
        // `func NewSigner(kid string, key []byte, method jwt.SigningMethod, claims jwt.Claims) endpoint.Middleware`
        m.getTarget().hasQualifiedName("github.com/go-kit/kit/auth/jwt", "NewSigner")
      |
        this = m.getArgument(1)
      )
    }
  }

  private class LestrratJwk extends Sink {
    LestrratJwk() {
      exists(DataFlow::CallNode m, string pkg |
        pkg.matches([
            "github.com/lestrrat-go/jwx", "github.com/lestrrat/go-jwx/jwk",
            "github.com/lestrrat-go/jwx%/jwk"
          ]) and
        // `func New(key interface{}) (Key, error)`
        m.getTarget().hasQualifiedName(pkg, "New")
      |
        this = m.getArgument(0)
      )
    }
  }

  /**
   * Sanitizes any other use of an operand to a comparison, on the assumption that this may filter
   * out special constant values -- for example, in context `if key != "invalid_key" { ... }`,
   * if `"invalid_key"` is indeed the only dangerous key then guarded uses of `key` are likely
   * to be safe.
   *
   * TODO: Before promoting this query look at replacing this with something more principled.
   */
  private class CompareExprSanitizer extends Sanitizer {
    CompareExprSanitizer() {
      exists(ComparisonExpr c |
        c.getAnOperand().getGlobalValueNumber() = this.asExpr().getGlobalValueNumber() and
        not this.asExpr() instanceof Literal
      )
    }
  }

  /**
   * Marks anything returned with an error as a sanitized.
   *
   * Typically this means contexts like `return "", errors.New("Oh no")`,
   * where we can be reasonably confident downstream users won't mistake
   * that empty string for a usable key.
   */
  private class ReturnedAlongsideErrorSanitizer extends Sanitizer {
    ReturnedAlongsideErrorSanitizer() {
      exists(ReturnStmt r, DataFlow::CallNode c |
        c.getTarget().hasQualifiedName("errors", "New") and
        r.getNumChild() > 1 and
        r.getAChild() = c.getAResult().getASuccessor*().asExpr() and
        r.getAChild() = this.asExpr()
      )
    }
  }

  /**
   * Marks anything returned alongside an error-value that is known
   * to be non-nil by virtue of a guarding check as harmless.
   *
   * For example, `if err != nil { return "", err }` is unlikely to be
   * contributing a dangerous hardcoded key.
   */
  private class ReturnedAlongsideErrorSanitizerGuard extends Sanitizer {
    ReturnedAlongsideErrorSanitizerGuard() {
      exists(ControlFlow::ConditionGuardNode guard, SsaWithFields errorVar, ReturnStmt r |
        guard.ensuresNeq(errorVar.getAUse(), Builtin::nil().getARead()) and
        guard.dominates(this.getBasicBlock()) and
        r.getExpr(1) = errorVar.getAUse().asExpr() and
        this.asExpr() = r.getExpr(0)
      )
    }
  }

  /** Mark any formatting string call as a sanitizer */
  private class FormattingSanitizer extends Sanitizer {
    FormattingSanitizer() { exists(Formatting::StringFormatCall s | s.getAResult() = this) }
  }

  private string getRandIntFunctionName() {
    result =
      [
        "ExpFloat64", "Float32", "Float64", "Int", "Int31", "Int31n", "Int63", "Int63n", "Intn",
        "NormFloat64", "Uint32", "Uint64"
      ]
  }

  private DataFlow::CallNode getARandIntCall() {
    result.getTarget().hasQualifiedName("math/rand", getRandIntFunctionName()) or
    result.getTarget().(Method).hasQualifiedName("math/rand", "Rand", getRandIntFunctionName()) or
    result.getTarget().hasQualifiedName("crypto/rand", "Int")
  }

  private DataFlow::CallNode getARandReadCall() {
    result.getTarget().hasQualifiedName("crypto/rand", "Read")
  }

  /**
   * Mark any taint arising from a read on a tainted slice with a random index as a
   * sanitizer for all instances of the taint
   */
  private class RandSliceSanitizer extends Sanitizer {
    RandSliceSanitizer() {
      exists(DataFlow::Node randomValue, DataFlow::Node index |
        // Sanitize flows like this:
        // func GenerateCryptoString(n int) (string, error) {
        //   const chars = "123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-"
        //   ret := make([]byte, n)
        //   for i := range ret {
        //     num, err := crand.Int(crand.Reader, big.NewInt(int64(len(chars))))
        //     if err != nil {
        //       return "", err
        //     }
        //     ret[i] = chars[num.Int64()]
        //   }
        //   return string(ret), nil
        // }
        randomValue = getARandIntCall().getAResult()
        or
        // Sanitize flows like :
        // func GenerateRandomString(size int) string {
        //   var bytes = make([]byte, size)
        //   rand.Read(bytes)
        //   for i, x := range bytes {
        //     bytes[i] = characters[x%byte(len(characters))]
        //   }
        //   return string(bytes)
        // }
        randomValue =
          any(DataFlow::PostUpdateNode pun |
            pun.getPreUpdateNode() = getARandReadCall().getArgument(0)
          )
      |
        TaintTracking::localTaint(randomValue, index) and
        this.(DataFlow::ElementReadNode).reads(_, index)
      )
    }
  }

  /**
   * Models flow from a call to `Int64` if the receiver is tainted
   */
  private class BigIntFlow extends TaintTracking::FunctionModel {
    BigIntFlow() { this.(Method).hasQualifiedName("math/big", "Int", "Int64") }

    override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
      inp.isReceiver() and
      outp.isResult(0)
    }
  }

  /*
   * Models taint flow through a binary operation such as a
   * modulo `%` operation or an addition `+` operation
   */

  private class BinExpAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    // This is required to model the sanitizers for the `HardcodedKeys` query.
    // This is required to correctly detect a sanitizer such as the one shown below.
    // func GenerateRandomString(size int) string {
    //   var bytes = make([]byte, size)
    //   rand.Read(bytes)
    //   for i, x := range bytes {
    //     bytes[i] = characters[x%byte(len(characters))]
    //   }
    //   return string(bytes)
    // }
    override predicate step(DataFlow::Node prev, DataFlow::Node succ) {
      exists(BinaryExpr b | b.getAnOperand() = prev.asExpr() | succ.asExpr() = b)
    }
  }

  /**
   * A configuration depicting taint flow for studying JWT token signing vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "Hard-coded JWT Signing Key" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

    override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof Sanitizer }
  }
}
