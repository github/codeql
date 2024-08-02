import go

/**
 * A abstract class which responsible for parsing a JWT token.
 */
abstract class JwtParseBase extends Function {
  /**
   * Gets argument number that responsible for JWT
   *
   * `-1` means the receiver is a argument node that responsible for JWT.
   *  In this case, we must declare some additional taint steps.
   */
  abstract int getTokenArgNum();

  /**
   * Gets Argument as DataFlow node that responsible for JWT
   */
  DataFlow::Node getTokenArg() {
    this.getTokenArgNum() != -1 and result = this.getACall().getArgument(this.getTokenArgNum())
    or
    this.getTokenArgNum() = -1 and result = this.getACall().getReceiver()
  }
}

/**
 * A abstract class which responsible for parsing a JWT token which the key parameter is a function type.
 *
 * Extends this class for Jwt parsing methods that accepts a function type as key.
 */
abstract class JwtParseWithKeyFunction extends JwtParseBase {
  /**
   * Gets argument number that responsible for a function returning the secret key
   */
  abstract int getKeyFuncArgNum();

  /**
   * Gets Argument as DataFlow node that responsible for a function returning the secret key
   */
  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 * A abstract class which responsible for parsing a JWT token which the key parameter can be a string or byte type.
 *
 * Extends this class for Jwt parsing methods that accepts a non-function type as key.
 */
abstract class JwtParse extends JwtParseBase {
  /**
   * Gets argument number that responsible for secret key
   */
  abstract int getKeyArgNum();

  /**
   * Gets Argument as DataFlow node that responsible for secret key
   */
  DataFlow::Node getKeyArg() { result = this.getACall().getArgument(this.getKeyArgNum()) }
}

/**
 * A abstract class which responsible for parsing a JWT without verifying it
 *
 * Extends this class for Jwt parsing methods that don't verify JWT signature
 */
abstract class JwtUnverifiedParse extends JwtParseBase { }

/**
 * Gets `github.com/golang-jwt/jwt` and `github.com/dgrijalva/jwt-go`(previous name of `golang-jwt`) JWT packages
 */
string golangJwtPackage() {
  result = package(["github.com/golang-jwt/jwt", "github.com/dgrijalva/jwt-go"], "")
}

/**
 * A class that contains the following function and method:
 *
 * func (p *Parser) Parse(tokenString string, keyFunc Keyfunc)
 *
 * func Parse(tokenString string, keyFunc Keyfunc)
 */
class GolangJwtParse extends JwtParseWithKeyFunction {
  GolangJwtParse() {
    exists(Function f | f.hasQualifiedName(golangJwtPackage(), "Parse") | this = f)
    or
    exists(Method f | f.hasQualifiedName(golangJwtPackage(), "Parser", "Parse") | this = f)
  }

  override int getKeyFuncArgNum() { result = 1 }

  override int getTokenArgNum() { result = 0 }
}

/**
 * A class that contains the following function and method:
 *
 * func (p *Parser) ParseWithClaims(tokenString string, claims Claims, keyFunc Keyfunc)
 *
 * func ParseWithClaims(tokenString string, claims Claims, keyFunc Keyfunc)
 */
class GolangJwtParseWithClaims extends JwtParseWithKeyFunction {
  GolangJwtParseWithClaims() {
    exists(Function f | f.hasQualifiedName(golangJwtPackage(), "ParseWithClaims") | this = f)
    or
    exists(Method f | f.hasQualifiedName(golangJwtPackage(), "Parser", "ParseWithClaims") |
      this = f
    )
  }

  override int getKeyFuncArgNum() { result = 2 }

  override int getTokenArgNum() { result = 0 }
}

/**
 * A class that contains the following method:
 *
 * func (p *Parser) ParseUnverified(tokenString string, claims Claims)
 */
class GolangJwtParseUnverified extends JwtUnverifiedParse {
  GolangJwtParseUnverified() {
    exists(Method f | f.hasQualifiedName(golangJwtPackage(), "Parser", "ParseUnverified") |
      this = f
    )
  }

  override int getTokenArgNum() { result = 0 }
}

/**
 * Gets `github.com/golang-jwt/jwt` and `github.com/dgrijalva/jwt-go`(previous name of `golang-jwt`) JWT packages
 */
string golangJwtRequestPackage() {
  result = package(["github.com/golang-jwt/jwt", "github.com/dgrijalva/jwt-go"], "request")
}

/**
 * A class that contains the following function:
 *
 * func ParseFromRequest(req *http.Request, extractor Extractor, keyFunc jwt.Keyfunc, options ...ParseFromRequestOption)
 */
class GolangJwtParseFromRequest extends JwtParseWithKeyFunction {
  GolangJwtParseFromRequest() {
    exists(Function f | f.hasQualifiedName(golangJwtRequestPackage(), "ParseFromRequest") |
      this = f
    )
  }

  override int getKeyFuncArgNum() { result = 2 }

  override int getTokenArgNum() { result = 0 }
}

/**
 * A class that contains the following function:
 *
 * func ParseFromRequestWithClaims(req *http.Request, extractor Extractor, claims jwt.Claims, keyFunc jwt.Keyfunc)
 */
class GolangJwtParseFromRequestWithClaims extends JwtParseWithKeyFunction {
  GolangJwtParseFromRequestWithClaims() {
    exists(Function f |
      f.hasQualifiedName(golangJwtRequestPackage(), "ParseFromRequestWithClaims")
    |
      this = f
    )
  }

  override int getKeyFuncArgNum() { result = 3 }

  override int getTokenArgNum() { result = 0 }
}

/**
 * Gets `gopkg.in/square/go-jose` and `github.com/go-jose/go-jose` jwt package
 */
string goJoseJwtPackage() {
  result =
    package([
        "gopkg.in/square/go-jose", "gopkg.in/go-jose/go-jose", "github.com/square/go-jose",
        "github.com/go-jose/go-jose"
      ], "jwt")
}

/**
 * A class that contains the following method:
 *
 * func (t *JSONWebToken) Claims(key interface{}, dest ...interface{})
 */
class GoJoseParseWithClaims extends JwtParse {
  GoJoseParseWithClaims() {
    exists(Method f | f.hasQualifiedName(goJoseJwtPackage(), "JSONWebToken", "Claims") | this = f)
  }

  override int getKeyArgNum() { result = 0 }

  override int getTokenArgNum() { result = -1 }
}

/**
 * A class that contains the following method:
 *
 * func (t *JSONWebToken) UnsafeClaimsWithoutVerification(dest ...interface{})
 */
class GoJoseUnsafeClaims extends JwtUnverifiedParse {
  GoJoseUnsafeClaims() {
    exists(Method f |
      f.hasQualifiedName(goJoseJwtPackage(), "JSONWebToken", "UnsafeClaimsWithoutVerification")
    |
      this = f
    )
  }

  override int getTokenArgNum() { result = -1 }
}

/**
 * Holds for general additional steps related to parsing the secret keys in `golang-jwt/jwt`,`dgrijalva/jwt-go` packages
 */
predicate golangJwtIsAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(Function f, DataFlow::CallNode call |
    (
      f.hasQualifiedName(package("github.com/golang-jwt/jwt", ""),
        [
          "ParseECPrivateKeyFromPEM", "ParseECPublicKeyFromPEM", "ParseEdPrivateKeyFromPEM",
          "ParseEdPublicKeyFromPEM", "ParseRSAPrivateKeyFromPEM", "ParseRSAPublicKeyFromPEM",
          "RegisterSigningMethod"
        ]) or
      f.hasQualifiedName(package("github.com/dgrijalva/jwt-go", ""),
        [
          "ParseECPrivateKeyFromPEM", "ParseECPublicKeyFromPEM", "ParseRSAPrivateKeyFromPEM",
          "ParseRSAPrivateKeyFromPEMWithPassword", "ParseRSAPublicKeyFromPEM"
        ])
    ) and
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call.getResult(0)
    or
    (
      f instanceof GolangJwtParse
      or
      f instanceof GolangJwtParseWithClaims
    ) and
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call.getResult(0)
  )
}

/**
 * Holds for general additioanl steps related to parsing the secret keys in `go-jose` package
 */
predicate goJoseIsAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(Function f, DataFlow::CallNode call |
    f.hasQualifiedName(goJoseJwtPackage(), ["ParseEncrypted", "ParseSigned"]) and
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call.getResult(0)
  )
  or
  exists(Method m, DataFlow::CallNode call |
    m.hasQualifiedName(goJoseJwtPackage(), "NestedJSONWebToken", "ParseSignedAndEncrypted") and
    call = m.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call.getResult(0)
    or
    m.hasQualifiedName(goJoseJwtPackage(), "NestedJSONWebToken", "Decrypt") and
    call = m.getACall() and
    nodeFrom = call.getReceiver() and
    nodeTo = call.getResult(0)
  )
}
