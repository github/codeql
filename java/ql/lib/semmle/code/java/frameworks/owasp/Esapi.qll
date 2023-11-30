/** Classes and predicates for reasoning about the `owasp.easpi` package. */

import java

/**
 * The `org.owasp.esapi.Validator` interface.
 */
class EsapiValidator extends RefType {
  EsapiValidator() { this.hasQualifiedName("org.owasp.esapi", "Validator") }
}

/**
 * The methods of `org.owasp.esapi.Validator` which validate data.
 */
class EsapiIsValidMethod extends Method {
  EsapiIsValidMethod() {
    this.getDeclaringType() instanceof EsapiValidator and
    this.hasName([
        "isValidCreditCard", "isValidDate", "isValidDirectoryPath", "isValidDouble",
        "isValidFileContent", "isValidFileName", "isValidInput", "isValidInteger",
        "isValidListItem", "isValidNumber", "isValidPrintable", "isValidRedirectLocation",
        "isValidSafeHTML", "isValidURI"
      ])
  }
}

/**
 * The methods of `org.owasp.esapi.Validator` which return validated data.
 */
class EsapiGetValidMethod extends Method {
  EsapiGetValidMethod() {
    this.getDeclaringType() instanceof EsapiValidator and
    this.hasName([
        "getValidCreditCard", "getValidDate", "getValidDirectoryPath", "getValidDouble",
        "getValidFileContent", "getValidFileName", "getValidInput", "getValidInteger",
        "getValidListItem", "getValidNumber", "getValidPrintable", "getValidRedirectLocation",
        "getValidSafeHTML", "getValidURI"
      ])
  }
}
