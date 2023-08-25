import go

module JWT {

string packageLestrrat() {
    result =
    package("github.com/lestrrat-go/jwx/v2/jwt", "")

}
string packagePathModern() {
    result =
      package(["github.com/golang-jwt/jwt/v5", "github.com/golang-jwt/jwt/v4"], "")
  }
  string packagePathOld(){
    result =
      package(
          "github.com/golang-jwt/jwt", "")
  }
  
  class NewParser extends Function {
    NewParser() {
      this.hasQualifiedName([packagePathModern()], "NewParser")
    }
  }
  
  class WithValidMethods extends Function{
    WithValidMethods() {
      this.hasQualifiedName([packagePathModern()], "WithValidMethods")
    }
  }
  
  class SafeJWTParserMethod extends Method {
    SafeJWTParserMethod() {
      this.hasQualifiedName(packagePathModern(), "Parser", ["Parse", "ParseWithClaims"])
    }
  }
  
  class SafeJWTParserFunc extends Function{
    SafeJWTParserFunc(){
    this.hasQualifiedName([packagePathModern(),packagePathOld()], ["Parse", "ParseWithClaims"])
    }
  }
  
  class UnafeJWTParserMethod extends Method{
    UnafeJWTParserMethod(){
    this.hasQualifiedName(packagePathModern(), "Parser", "ParseUnverified")
    }
  }
  class LestrratParse extends Function{
    LestrratParse() {
        this.hasQualifiedName(packageLestrrat(), "Parse")
    }
  }
  class LestrratSafeOptions extends Function{
    LestrratSafeOptions() {
        this.hasQualifiedName(packageLestrrat(), ["WithKey", "WithKeySet"])
    }
  }
  class LestrratParseInsecure extends Function{
    LestrratParseInsecure() {
        this.hasQualifiedName(packageLestrrat(), "ParseInsecure")
    }
  }

}
