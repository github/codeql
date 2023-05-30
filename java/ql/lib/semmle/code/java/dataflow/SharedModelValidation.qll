/**
 * INTERNAL: Do not use.
 *
 * Provides classes for validating kinds in models as data rows.
 * Such that we can share this logic across our CodeQL analysis of different languages.
 */
class ValidSinkKind extends string {
  ValidSinkKind() {
    this =
      [
        // shared ALL languages
        "request-forgery", "ldap-injection", "sql-injection", "nosql-injection", "log-injection",
        "xpath-injection", "html-injection", "js-injection", "url-redirection", "path-injection",
        "file-content-store", "hostname-verification", "response-splitting", "information-leak",
        "xslt-injection", "template-injection", "fragment-injection", "command-injection",
        "unsafe-deserialization", "xxe", "database-store", "format-string",
        // .matches("credentials-%"), .matches("regex-use%")"
        // shared MOST languages
        "code-injection", // .matches("encryption-%"),
        // Java only
        "jndi-injection", "mvel-injection", "groovy-injection", "ognl-injection", "jexl-injection",
        "bean-validation", "intent-redirection", "pending-intents",
        // JS only
        "mongodb.sink",
        // Swift only
        "preferences-store", "transmission", "predicate-injection", "webview-fetch",
        "tls-protocol-version", "hash-iteration-count" // .matches("%string-%length"), .matches("weak-hash-input-")
      ]
  }
}
