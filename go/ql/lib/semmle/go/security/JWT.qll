import go

/**
 * func (p *Parser) Parse(tokenString string, keyFunc Keyfunc)
 * func Parse(tokenString string, keyFunc Keyfunc)
 */
class GolangJwtParse extends Function {
  GolangJwtParse() {
    exists(DataFlow::Function f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt", "github.com/golang-jwt/jwt/v4",
          "github.com/golang-jwt/jwt/v5", "github.com/dgrijalva/jwt-go",
          "github.com/dgrijalva/jwt-go/v4",
        ], "Parse")
    |
      this = f
    )
    or
    exists(DataFlow::Method f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt.Parser", "github.com/golang-jwt/jwt/v4.Parser",
          "github.com/golang-jwt/jwt/v5.Parser", "github.com/dgrijalva/jwt-go.Parser",
          "github.com/dgrijalva/jwt-go/v4.Parser"
        ], "Parse")
    |
      this = f
    )
  }

  int getKeyFuncArgNum() { result = 1 }

  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 * func (p *Parser) Parse(tokenString string, keyFunc Keyfunc)
 * func Parse(tokenString string, keyFunc Keyfunc)
 */
class GolangJwtValidField extends DataFlow::FieldReadNode {
  GolangJwtValidField() {
    this.getField()
        .hasQualifiedName([
              "github.com/golang-jwt/jwt", "github.com/golang-jwt/jwt/v4",
              "github.com/golang-jwt/jwt/v5", "github.com/dgrijalva/jwt-go",
              "github.com/dgrijalva/jwt-go/v4"
            ] + ".Token", "Valid")
  }
}

/**
 * func (p *Parser) ParseWithClaims(tokenString string, claims Claims, keyFunc Keyfunc)
 * func ParseWithClaims(tokenString string, claims Claims, keyFunc Keyfunc)
 */
class GolangJwtParseWithClaims extends Function {
  GolangJwtParseWithClaims() {
    exists(DataFlow::Function f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt", "github.com/golang-jwt/jwt/v4",
          "github.com/golang-jwt/jwt/v5", "github.com/dgrijalva/jwt-go",
          "github.com/dgrijalva/jwt-go/v4"
        ], "ParseWithClaims")
    |
      this = f
    )
    or
    exists(DataFlow::Method f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt.Parser", "github.com/golang-jwt/jwt/v4.Parser",
          "github.com/golang-jwt/jwt/v5.Parser", "github.com/dgrijalva/jwt-go.Parser",
          "github.com/dgrijalva/jwt-go/v4.Parser"
        ], "ParseWithClaims")
    |
      this = f
    )
  }

  int getKeyFuncArgNum() { result = 2 }

  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 * func (p *Parser) ParseUnverified(tokenString string, claims Claims)
 */
class GolangJwtParseUnverified extends Function {
  GolangJwtParseUnverified() {
    exists(DataFlow::Method f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt.Parser", "github.com/golang-jwt/jwt/v4.Parser",
          "github.com/golang-jwt/jwt/v5.Parser", "github.com/dgrijalva/jwt-go.Parser",
          "github.com/dgrijalva/jwt-go/v4.Parser"
        ], "ParseUnverified")
    |
      this = f
    )
  }
}

/**
 * func ParseFromRequest(req *http.Request, extractor Extractor, keyFunc jwt.Keyfunc, options ...ParseFromRequestOption)
 */
class GolangJwtParseFromRequest extends Function {
  GolangJwtParseFromRequest() {
    exists(DataFlow::Function f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt/request", "github.com/golang-jwt/jwt/v4/request",
          "github.com/dgrijalva/jwt-go/request", "github.com/golang-jwt/jwt/v4/request",
          "github.com/dgrijalva/jwt-go/v5/request"
        ], "ParseFromRequest")
    |
      this = f
    )
  }

  int getKeyFuncArgNum() { result = 2 }

  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 * func ParseFromRequestWithClaims(req *http.Request, extractor Extractor, claims jwt.Claims, keyFunc jwt.Keyfunc)
 */
class GolangJwtParseFromRequestWithClaims extends Function {
  GolangJwtParseFromRequestWithClaims() {
    exists(DataFlow::Function f |
      f.hasQualifiedName([
          "github.com/golang-jwt/jwt/request", "github.com/golang-jwt/jwt/v4/request",
          "github.com/dgrijalva/jwt-go/request", "github.com/golang-jwt/jwt/v4/request",
          "github.com/dgrijalva/jwt-go/v5/request"
        ], "ParseFromRequestWithClaims")
    |
      this = f
    )
  }

  int getKeyFuncArgNum() { result = 3 }

  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 *func (t *JSONWebToken) Claims(key interface{}, dest ...interface{})
 */
class GoJoseClaims extends Function {
  GoJoseClaims() {
    exists(DataFlow::Method f |
      f.hasQualifiedName([
          "gopkg.in/square/go-jose/jwt.JSONWebToken", "gopkg.in/square/go-jose.v2/jwt.JSONWebToken",
          "gopkg.in/square/go-jose.v3/jwt.JSONWebToken",
          "github.com/go-jose/go-jose/jwt.JSONWebToken",
          "github.com/go-jose/go-jose/v3/jwt.JSONWebToken"
        ], "Claims")
    |
      this = f
    )
  }

  int getKeyFuncArgNum() { result = 1 }

  DataFlow::Node getKeyFuncArg() { result = this.getACall().getArgument(this.getKeyFuncArgNum()) }
}

/**
 *  func (t *JSONWebToken) UnsafeClaimsWithoutVerification(dest ...interface{})
 */
class GoJoseUnsafeClaims extends Function {
  GoJoseUnsafeClaims() {
    exists(DataFlow::Method f |
      f.hasQualifiedName([
          "gopkg.in/square/go-jose/jwt.JSONWebToken", "gopkg.in/square/go-jose.v2/jwt.JSONWebToken",
          "gopkg.in/square/go-jose.v3/jwt.JSONWebToken",
          "github.com/go-jose/go-jose/jwt.JSONWebToken",
          "github.com/go-jose/go-jose/v3/jwt.JSONWebToken"
        ], "UnsafeClaimsWithoutVerification")
    |
      this = f
    )
  }
}

predicate golangJwtIsAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(DataFlow::Function f, DataFlow::CallNode call |
    f.hasQualifiedName([
        "github.com/golang-jwt/jwt", "github.com/golang-jwt/jwt/v4", "github.com/golang-jwt/jwt/v5",
        "github.com/dgrijalva/jwt-go", "github.com/dgrijalva/jwt-go/v4"
      ],
      [
        "ParseECPrivateKeyFromPEM", "ParseECPublicKeyFromPEM", "ParseEdPrivateKeyFromPEM",
        "ParseEdPublicKeyFromPEM", "ParseRSAPrivateKeyFromPEM", "ParseRSAPublicKeyFromPEM",
        "RegisterSigningMethod"
      ])
  |
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call
  )
  or
  exists(DataFlow::Function f, DataFlow::CallNode call |
    f instanceof GolangJwtParse
    or
    f instanceof GolangJwtParseWithClaims
  |
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call
  )
  or
  exists(DataFlow::FieldReadNode f | f instanceof GolangJwtValidField |
    nodeFrom = f.getBase() and
    nodeTo = f
  )
}

predicate test(DataFlow::Function f, DataFlow::CallNode call) {
  f.hasQualifiedName([
      "gopkg.in/square/go-jose/jwt", "gopkg.in/square/go-jose.v2/jwt",
      "gopkg.in/square/go-jose.v3/jwt", "github.com/go-jose/go-jose/jwt",
      "github.com/go-jose/go-jose/v3/jwt"
    ], ["ParseEncrypted", "ParseSigned",]) and
  call = f.getACall().getArgument(0)
}

predicate goJoseIsAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(DataFlow::Function f, DataFlow::CallNode call |
    f.hasQualifiedName([
        "gopkg.in/square/go-jose/jwt", "gopkg.in/square/go-jose.v2/jwt",
        "gopkg.in/square/go-jose.v3/jwt", "github.com/go-jose/go-jose/jwt",
        "github.com/go-jose/go-jose/v3/jwt"
      ], ["ParseEncrypted", "ParseSigned",])
  |
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call
  )
  or
  exists(DataFlow::Function f, DataFlow::CallNode call |
    f.hasQualifiedName([
        "gopkg.in/square/go-jose/jwt.NestedJSONWebToken",
        "gopkg.in/square/go-jose.v2/jwt.NestedJSONWebToken",
        "gopkg.in/square/go-jose.v3/jwt.NestedJSONWebToken",
        "github.com/go-jose/go-jose/jwt.NestedJSONWebToken",
        "github.com/go-jose/go-jose/v3/jw.NestedJSONWebTokent"
      ], "ParseSignedAndEncrypted")
  |
    call = f.getACall() and
    nodeFrom = call.getArgument(0) and
    nodeTo = call
  )
  or
  exists(DataFlow::Method f, DataFlow::CallNode call |
    f.hasQualifiedName([
        "gopkg.in/square/go-jose/jwt.NestedJSONWebToken",
        "gopkg.in/square/go-jose.v2/jwt.NestedJSONWebToken",
        "gopkg.in/square/go-jose.v3/jwt.NestedJSONWebToken",
        "github.com/go-jose/go-jose/jwt.NestedJSONWebToken",
        "github.com/go-jose/go-jose/v3/jw.NestedJSONWebTokent"
      ], "Decrypt")
  |
    call = f.getACall() and
    nodeFrom = call.getReceiver() and
    nodeTo = call
  )
}
