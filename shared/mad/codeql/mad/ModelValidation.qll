/**
 * Provides classes and predicates related to validating models-as-data rows.
 */

/** Provides predicates for determining if a model exists for a given `kind`. */
signature module KindValidationConfigSig {
  /** Holds if a summary model exists for the given `kind`. */
  predicate summaryKind(string kind);

  /** Holds if a sink model exists for the given `kind`. */
  predicate sinkKind(string kind);

  /** Holds if a source model exists for the given `kind`. */
  predicate sourceKind(string kind);

  /** Holds if a neutral model exists for the given `kind`. */
  default predicate neutralKind(string kind) { none() }
}

/** Provides validation for models-as-data summary, sink, source, and neutral kinds. */
module KindValidation<KindValidationConfigSig Config> {
  /** A valid models-as-data sink kind. */
  private class ValidSinkKind extends string {
    bindingset[this]
    ValidSinkKind() {
      this =
        [
          // shared
          "code-injection", "command-injection", "environment-injection", "file-content-store",
          "html-injection", "js-injection", "ldap-injection", "log-injection", "path-injection",
          "request-forgery", "sql-injection", "url-redirection",
          // Java-only currently, but may be shared in the future
          "bean-validation", "fragment-injection", "groovy-injection", "hostname-verification",
          "information-leak", "intent-redirection", "jexl-injection", "jndi-injection",
          "mvel-injection", "notification", "ognl-injection", "pending-intents",
          "response-splitting", "trust-boundary-violation", "template-injection", "url-forward",
          "xpath-injection", "xslt-injection",
          // JavaScript-only currently, but may be shared in the future
          "mongodb.sink", "nosql-injection", "unsafe-deserialization",
          // Swift-only currently, but may be shared in the future
          "database-store", "format-string", "hash-iteration-count", "predicate-injection",
          "preferences-store", "tls-protocol-version", "transmission", "webview-fetch", "xxe",
          // Go-only currently, but may be shared in the future
          "jwt",
          // CPP-only currently
          "remote-sink"
        ]
      or
      this.matches([
          // shared
          "credentials-%", "encryption-%", "qltest%", "test-%",
          // Java-only currently, but may be shared in the future
          "regex-use%",
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
          "local", "remote", "file", "commandargs", "database", "environment",
          // Java
          "android-external-storage-dir", "contentprovider",
          // C#
          "file-write", "windows-registry",
          // JavaScript
          "database-access-result"
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
          // Dynamic languages
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
    exists(string kind | Config::summaryKind(kind) |
      not kind instanceof ValidSummaryKind and
      result = "Invalid kind \"" + kind + "\" in summary model."
    )
    or
    exists(string kind, string msg | Config::sinkKind(kind) |
      not kind instanceof ValidSinkKind and
      msg = "Invalid kind \"" + kind + "\" in sink model." and
      // The part of this message that refers to outdated sink kinds can be deleted after June 1st, 2024.
      if kind instanceof OutdatedSinkKind
      then result = msg + " " + kind.(OutdatedSinkKind).outdatedMessage()
      else result = msg
    )
    or
    exists(string kind | Config::sourceKind(kind) |
      not kind instanceof ValidSourceKind and
      result = "Invalid kind \"" + kind + "\" in source model."
    )
    or
    exists(string kind | Config::neutralKind(kind) |
      not kind instanceof ValidNeutralKind and
      result = "Invalid kind \"" + kind + "\" in neutral model."
    )
  }
}
