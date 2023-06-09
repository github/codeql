/**
 * Provides classes and predicates related to validating models-as-data rows.
 */

/** Holds if a model exists for the given `kind`. */
signature predicate modelKindSig(string kind);

/** Provides validation for models-as-data summary, sink, source, and neutral kinds. */
module KindValidation<
  modelKindSig/1 summaryKind, modelKindSig/1 sinkKind, modelKindSig/1 sourceKind,
  modelKindSig/1 neutralKind>
{
  /** A valid models-as-data sink kind. */
  private class ValidSinkKind extends string {
    bindingset[this]
    ValidSinkKind() {
      this =
        [
          // shared
          "code-injection", "command-injection", "file-content-store", "html-injection",
          "js-injection", "ldap-injection", "log-injection", "path-injection", "request-forgery",
          "sql-injection", "url-redirection",
          // Java-only currently, but may be shared in the future
          "bean-validation", "fragment-injection", "groovy-injection", "hostname-verification",
          "information-leak", "intent-redirection", "jexl-injection", "jndi-injection",
          "mvel-injection", "ognl-injection", "pending-intents", "response-splitting",
          "template-injection", "xpath-injection", "xslt-injection",
          // JavaScript-only currently, but may be shared in the future
          "mongodb.sink", "nosql-injection", "unsafe-deserialization",
          // Swift-only currently, but may be shared in the future
          "database-store", "format-string", "hash-iteration-count", "predicate-injection",
          "preferences-store", "tls-protocol-version", "transmission", "webview-fetch", "xxe"
        ]
      or
      this.matches([
          // shared
          "encryption-%", "qltest%", "test-%",
          // Java-only currently, but may be shared in the future
          "regex-use%",
          // JavaScript-only currently, but may be shared in the future
          "credentials-%",
          // Swift-only currently, but may be shared in the future
          "%string-%length", "weak-hash-input-%"
        ])
    }
  }

  /** An outdated models-as-data sink kind. */
  private class OutdatedSinkKind extends string {
    OutdatedSinkKind() {
      this =
        [
          "sql", "url-redirect", "xpath", "ssti", "logging", "groovy", "jexl", "mvel", "xslt",
          "ldap", "pending-intent-sent", "intent-start", "set-hostname-verifier",
          "header-splitting", "xss", "write-file", "create-file", "read-file", "open-url",
          "jdbc-url", "command-line-injection", "code", "html", "remote",
          "uncontrolled-format-string", "js-eval"
        ]
    }

    /** Gets a replacement kind for an outdated sink kind. */
    private string replacementKind() {
      this = ["sql", "xpath", "groovy", "jexl", "mvel", "xslt", "ldap", "code", "html"] and
      result = this + "-injection"
      or
      this = "js-eval" and result = "code-injection"
      or
      this = "url-redirect" and result = "url-redirection"
      or
      this = "ssti" and result = "template-injection"
      or
      this = "logging" and result = "log-injection"
      or
      this = "pending-intent-sent" and result = "pending-intents"
      or
      this = "intent-start" and result = "intent-redirection"
      or
      this = "set-hostname-verifier" and result = "hostname-verification"
      or
      this = "header-splitting" and result = "response-splitting"
      or
      this = "xss" and result = "html-injection\" or \"js-injection"
      or
      this = ["write-file", "remote"] and result = "file-content-store"
      or
      this = ["create-file", "read-file"] and result = "path-injection"
      or
      this = ["open-url", "jdbc-url"] and result = "request-forgery"
      or
      this = "command-line-injection" and result = "command-injection"
      or
      this = "uncontrolled-format-string" and result = "format-string"
    }

    /** Gets an error message for an outdated sink kind. */
    string outdatedMessage() {
      result =
        "The kind \"" + this + "\" is outdated. Use \"" + this.replacementKind() + "\" instead."
    }
  }

  /** A valid models-as-data source kind. */
  private class ValidSourceKind extends string {
    bindingset[this]
    ValidSourceKind() {
      this =
        [
          // shared
          "local", "remote",
          // Java
          "android-external-storage-dir", "contentprovider",
          // C#
          "file", "file-write",
          // JavaScript
          "database-access-result", "remote-flow"
        ]
      or
      this.matches([
          // shared
          "qltest%", "test-%",
          // Swift
          "%string-%length"
        ])
    }
  }

  /** A valid models-as-data summary kind. */
  private class ValidSummaryKind extends string {
    ValidSummaryKind() {
      this =
        [
          // shared
          "taint", "value",
          // JavaScript
          "type"
        ]
    }
  }

  /** A valid models-as-data neutral kind. */
  private class ValidNeutralKind extends string {
    ValidNeutralKind() {
      this =
        [
          // Java/C# currently
          "sink", "source", "summary"
        ]
    }
  }

  /** Gets an error message relating to an invalid kind in a model. */
  string getInvalidModelKind() {
    exists(string kind | summaryKind(kind) |
      not kind instanceof ValidSummaryKind and
      result = "Invalid kind \"" + kind + "\" in summary model."
    )
    or
    exists(string kind, string msg | sinkKind(kind) |
      not kind instanceof ValidSinkKind and
      msg = "Invalid kind \"" + kind + "\" in sink model." and
      // The part of this message that refers to outdated sink kinds can be deleted after June 1st, 2024.
      if kind instanceof OutdatedSinkKind
      then result = msg + " " + kind.(OutdatedSinkKind).outdatedMessage()
      else result = msg
    )
    or
    exists(string kind | sourceKind(kind) |
      not kind instanceof ValidSourceKind and
      result = "Invalid kind \"" + kind + "\" in source model."
    )
    or
    exists(string kind | neutralKind(kind) |
      not kind instanceof ValidNeutralKind and
      result = "Invalid kind \"" + kind + "\" in neutral model."
    )
  }
}
