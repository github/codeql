/**
 * INTERNAL: Do not use.
 *
 * Provides classes and predicates for identifying strings that may indicate the presence of sensitive data.
 * Such that we can share this logic across our CodeQL analysis of different languages.
 *
 * 'Sensitive' data in general is anything that should not be sent around in unencrypted form.
 */

/**
 * A classification of different kinds of sensitive data:
 *
 *   - secret: generic secret or trusted data;
 *   - id: a user name or other account information;
 *   - password: a password or authorization key;
 *   - certificate: a certificate.
 *
 * While classifications are represented as strings, this should not be relied upon.
 * Instead, use the predicates in `SensitiveDataClassification::` to work with
 * classifications.
 */
class SensitiveDataClassification extends string {
  SensitiveDataClassification() { this in ["secret", "id", "password", "certificate"] }
}

/**
 * Provides predicates to select the different kinds of sensitive data we support.
 */
module SensitiveDataClassification {
  /** Gets the classification for secret or trusted data. */
  SensitiveDataClassification secret() { result = "secret" }

  /** Gets the classification for user names or other account information. */
  SensitiveDataClassification id() { result = "id" }

  /** Gets the classification for passwords or authorization keys. */
  SensitiveDataClassification password() { result = "password" }

  /** Gets the classification for certificates. */
  SensitiveDataClassification certificate() { result = "certificate" }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides heuristics for identifying names related to sensitive information.
 */
module HeuristicNames {
  /**
   * Gets a regular expression that identifies strings that may indicate the presence of secret
   * or trusted data.
   */
  string maybeSecret() { result = "(?is).*((?<!is)secret|(?<!un|is)trusted).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * user names or other account information.
   */
  string maybeAccountInfo() {
    result = "(?is).*acc(ou)?nt.*" or
    result = "(?is).*(puid|username|userid|session(id|key)).*" or
    result = "(?s).*([uU]|^|_|[a-z](?=U))([uU][iI][dD]).*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a password or an authorization key.
   */
  string maybePassword() {
    result = "(?is).*pass(wd|word|code|phrase)(?!.*question).*" or
    result = "(?is).*(auth(entication|ori[sz]ation)?)key.*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a certificate.
   */
  string maybeCertificate() { result = "(?is).*(cert)(?!.*(format|name)).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence
   * of sensitive data, with `classification` describing the kind of sensitive data involved.
   */
  string maybeSensitiveRegexp(SensitiveDataClassification classification) {
    result = maybeSecret() and classification = SensitiveDataClassification::secret()
    or
    result = maybeAccountInfo() and classification = SensitiveDataClassification::id()
    or
    result = maybePassword() and classification = SensitiveDataClassification::password()
    or
    result = maybeCertificate() and
    classification = SensitiveDataClassification::certificate()
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of data
   * that is hashed or encrypted, and hence rendered non-sensitive, or contains special characters
   * suggesting nouns within the string do not represent the meaning of the whole string (e.g. a URL or a SQL query).
   */
  string notSensitiveRegexp() {
    result =
      "(?is).*([^\\w$.-]|redact|censor|obfuscate|hash|md5|sha|random|((?<!un)(en))?(crypt|code)).*"
  }

  /**
   * DEPRECATED: Use `maybeSensitiveRegexp` instead.
   */
  deprecated predicate maybeSensitive = maybeSensitiveRegexp/1;

  /**
   * DEPRECATED: Use `notSensitiveRegexp` instead.
   */
  deprecated predicate notSensitive = notSensitiveRegexp/0;

  /**
   * Holds if `name` may indicate the presence of sensitive data, and
   * `name` does not indicate that the data is in fact non-sensitive (for example since
   * it is hashed or encrypted). `classification` describes the kind of sensitive data
   * involved.
   *
   * That is, one of the regexps from `maybeSensitiveRegexp` matches `name` (with the
   * given classification), and none of the regexps from `notSensitiveRegexp` matches
   * `name`.
   */
  bindingset[name]
  predicate nameIndicatesSensitiveData(string name, SensitiveDataClassification classification) {
    name.regexpMatch(maybeSensitiveRegexp(classification)) and
    not name.regexpMatch(notSensitiveRegexp())
  }
}
