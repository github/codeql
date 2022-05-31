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

  /**
   * A sanitizer guard for JWT token signing vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

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
  class HardcodedStringSource extends Source {
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
   * Mark any comparision expression where any operand is tainted as a
   * sanitizer for all instances of the taint
   */
  private class CompareExprSanitizer extends Sanitizer {
    CompareExprSanitizer() {
      exists(BinaryExpr c |
        c.getAnOperand().getGlobalValueNumber() = this.asExpr().getGlobalValueNumber()
      )
    }
  }

  /** Mark an empty string returned with an error as a sanitizer */
  class EmptyErrorSanitizer extends Sanitizer {
    EmptyErrorSanitizer() {
      exists(ReturnStmt r, DataFlow::CallNode c |
        c.getTarget().hasQualifiedName("errors", "New") and
        r.getNumChild() > 1 and
        r.getAChild() = c.getAResult().getASuccessor*().asExpr() and
        r.getAChild() = this.asExpr()
      )
    }
  }

  /** Mark any formatting string call as a sanitizer */
  class FormattingSanitizer extends Sanitizer {
    FormattingSanitizer() { exists(Formatting::StringFormatCall s | s.getAResult() = this) }
  }

  /**
   * Mark any taint arising from a read on a tainted slice with a random index as a
   * sanitizer for all instances of the taint
   */
  private class RandSliceSanitizer extends Sanitizer {
    RandSliceSanitizer() {
      exists(DataFlow::CallNode randint, string name, DataFlow::ElementReadNode r |
        (
          randint.getTarget().hasQualifiedName("math/rand", name) or
          randint.getTarget().(Method).hasQualifiedName("math/rand", "Rand", name)
        ) and
        name =
          [
            "ExpFloat64", "Float32", "Float64", "Int", "Int31", "Int31n", "Int63", "Int63n", "Intn",
            "NormFloat64", "Uint32", "Uint64"
          ] and
        r.reads(this, randint.getAResult().getASuccessor*())
      )
      or
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
      exists(
        DataFlow::CallNode randint, DataFlow::MethodCallNode bigint, DataFlow::ElementReadNode r
      |
        randint.getTarget().hasQualifiedName("crypto/rand", "Int") and
        bigint.getTarget().hasQualifiedName("math/big", "Int", "Int64") and
        bigint.getReceiver() = randint.getResult(0).getASuccessor*() and
        r.reads(this, bigint.getAResult().getASuccessor*())
      )
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
      exists(DataFlow::CallNode randread, DataFlow::Node rand, DataFlow::ElementReadNode r |
        randread.getTarget().hasQualifiedName("crypto/rand", "Read") and
        TaintTracking::localTaint(any(DataFlow::PostUpdateNode pun |
            pun.getPreUpdateNode() = randread.getArgument(0)
          ), rand) and
        (
          // Flow through a ModExpr if any of the operands are tainted.
          //  For ex, in the case shown above,
          // `bytes[i] = characters[x%byte(len(characters))]`
          // given x is cryptographically secure random number,
          // we can assume that `bytes` is random and cryptographically secure.
          exists(ModExpr e | e.getAnOperand() = rand.asExpr() |
            r.reads(this, e.getGlobalValueNumber().getANode())
          )
          or
          // This is an alternative case where the code uses `x` directly instead
          // `bytes[i] = characters[x]`
          r.reads(this.getAPredecessor*(), rand)
        )
      )
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

    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
      guard instanceof SanitizerGuard
    }
  }
}
